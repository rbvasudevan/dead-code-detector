CREATE TABLE deadcodedetector_repo (
  id         BIGINT             NOT NULL AUTO_INCREMENT,
  repo_id    VARCHAR(30) UNIQUE NOT NULL,
  repoUrl    VARCHAR(255),
  created_at DATETIME           NOT NULL,
  updated_at DATETIME           NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = InnoDB;