package com.devfactory.deadcodedetector.repository;


import com.devfactory.deadcodedetector.domain.Repo;
import org.springframework.data.repository.CrudRepository;

public interface RepoRepository extends CrudRepository<Repo, String> {

    public Repo findByRepoId(String id);

    public void deleteByRepoId(String repoID);
}

