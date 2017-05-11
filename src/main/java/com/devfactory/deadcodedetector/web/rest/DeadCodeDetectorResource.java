package com.devfactory.deadcodedetector.web.rest;

import static com.devfactory.deadcodedetector.config.Constants.API_V1_PATH;

import com.devfactory.deadcodedetector.domain.Repo;
import com.devfactory.deadcodedetector.services.DeadCodeDetectorService;
import java.io.IOException;
import javax.xml.ws.Response;
import org.eclipse.jgit.api.errors.GitAPIException;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = API_V1_PATH, produces = MediaType.APPLICATION_JSON_VALUE)
public class DeadCodeDetectorResource {

    private DeadCodeDetectorService deadCodeDetectorService;

    public DeadCodeDetectorResource(DeadCodeDetectorService deadCodeDetectorService) {
        this.deadCodeDetectorService = deadCodeDetectorService;
    }

    @PostMapping(value = "/addrepo")
    public Repo addRepo(@RequestParam String repoUrl, @RequestParam String projectName)
            throws IOException, GitAPIException {
        return deadCodeDetectorService.addRepository(repoUrl, projectName);
    }

    @GetMapping(value = "/listallrepo")
    public Iterable<Repo> getAllRepo() {
        return deadCodeDetectorService.getAllRepo();
    }

    @GetMapping(value = "/deadcodeoccurance",produces = MediaType.TEXT_PLAIN_VALUE)
    public ResponseEntity<String> getDeadCode(@RequestParam String repoId) throws IOException{
        return ResponseEntity.ok(deadCodeDetectorService.getDeadCodeOccurrence(repoId));
    }
}
