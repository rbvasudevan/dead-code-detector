package com.devfactory.deadcodedetector.services;

import com.devfactory.deadcodedetector.config.DeadCodeDetectorProperties;
import com.devfactory.deadcodedetector.domain.Repo;
import com.devfactory.deadcodedetector.domain.Status;
import com.devfactory.deadcodedetector.handler.DeadCodeDetectorException;
import com.devfactory.deadcodedetector.repository.RepoRepository;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.api.errors.GitAPIException;
import org.springframework.stereotype.Service;

@Service
public class DeadCodeDetectorService {

    private static final String UDB_EXTENSION = ".udb";

    private static final String UNDERSCORE = "_";

    private static final String TEXT = "_text";

    private RepoRepository repoRepository;

    private DeadCodeDetectorProperties deadCodeDetectorProperties;

    DeadCodeDetectorService(RepoRepository repoRepository, DeadCodeDetectorProperties deadCodeDetectorProperties) {
        this.repoRepository = repoRepository;
        this.deadCodeDetectorProperties = deadCodeDetectorProperties;
    }

    public Repo addRepository(String repoUrl, String projectName) throws IOException, GitAPIException {
        final String repoID = RandomStringUtils.randomAlphanumeric(10);
        final String BASE_LOCATION=deadCodeDetectorProperties.getLocalBaseLocation()
                + projectName + UNDERSCORE + repoID;
        File localPath = File.createTempFile(projectName,
                repoID, new File(deadCodeDetectorProperties.getLocalBaseLocation()));
        Repo repo = Repo.builder().repoUrl(repoUrl).repoId(repoID)
                .status(Status.ADDED)
                .repoLocalLocation(localPath.toString())
                .udbPath(BASE_LOCATION + UDB_EXTENSION)
                .reportFolder(BASE_LOCATION + TEXT)
                .build();
        executorService(repo, localPath);
        return repoRepository.save(repo);
    }

    private void executorService(Repo repo, File localPath) {
        ExecutorService executorService = Executors.newSingleThreadExecutor();
        executorService.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    if (!localPath.delete()) {
                        throw new IOException("Could not delete temporary file " + localPath);
                    }
                    Git result = Git.cloneRepository()
                            .setURI(repo.getRepoUrl())
                            .setDirectory(localPath)
                            .call();
                    repoRepository.save(getRepoForUpdate(repo.getRepoId(), Status.PROCESSING));
                    File file = new File(repo.getUdbPath());
                    if (file.createNewFile()) {
                        Process process = Runtime.getRuntime().exec(
                                String.format(deadCodeDetectorProperties.getExecutionCommand(), repo.getUdbPath(),
                                result.getRepository().getWorkTree().toString()));
                        process.waitFor();
                    }
                    repoRepository.save(getRepoForUpdate(repo.getRepoId(), Status.COMPLETED));
                } catch (GitAPIException | InterruptedException | IOException |RuntimeException  ex) {
                    Repo failedRepo=getRepoForUpdate(repo.getRepoId(),Status.FAILED);
                    failedRepo.setException(ex.getLocalizedMessage());
                    repoRepository.save(failedRepo);
                        throw new DeadCodeDetectorException("Error occured while creating & analyzing Repo :"
                                ,ex.getCause());
                }
            }
        });
        executorService.shutdown();
    }

    private Repo getRepoForUpdate(String repoId, Status status) {
        Repo repo = repoRepository.findByRepoId(repoId);
        repo.setStatus(status);
        return repo;
    }

    public Iterable<Repo> getAllRepo(){
        return repoRepository.findAll();
   }

    public String getDeadCodeOccurrence(String repoId)
    {
        StringBuilder deadCodeOccurrence = new StringBuilder();
        try {
            Files.list(Paths.get(repoRepository.findByRepoId(repoId).getReportFolder()))
                    .filter(p -> p.toString().contains("Unused")).forEach((p) -> {
                try {
                    deadCodeOccurrence.append(FileUtils.readFileToString(p.toFile(), "UTF-8"));
                } catch (RuntimeException| IOException e) {
                    throw new DeadCodeDetectorException("Error while getting the dead code occurrence :",e.getCause());
                }
            });
        }
        catch(RuntimeException | IOException ex){
            throw new DeadCodeDetectorException("Error while getting the dead code occurrence :",ex.getCause());
        }
        return deadCodeOccurrence.toString();
    }
}
