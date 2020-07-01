# drone-lerna

[![Build Status](https://drone.kilic.dev/api/badges/cenk1cenk2/drone-lerna/status.svg)](https://drone.kilic.dev/cenk1cenk2/drone-lerna)
[![Docker Pulls](https://img.shields.io/docker/pulls/cenk1cenk2/drone-lerna)](https://hub.docker.com/repository/docker/cenk1cenk2/drone-lerna)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/cenk1cenk2/drone-lerna)](https://hub.docker.com/repository/docker/cenk1cenk2/drone-lerna)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/cenk1cenk2/drone-lerna)](https://hub.docker.com/repository/docker/cenk1cenk2/drone-lerna)
[![GitHub last commit](https://img.shields.io/github/last-commit/cenk1cenk2/drone-lerna)](https://github.com/cenk1cenk2/drone-lerna)

Drone plugin for making semantic releases based on https://github.com/semantic-release/semantic-release. With some added twists ofc.

<!-- toc -->

- [Usage](#usage)
- [Custom Release File](#custom-release-file)
- [What it does](#what-it-does)

<!-- tocstop -->

## Usage

See [commit message format](https://github.com/semantic-release/semantic-release#commit-message-format) to use it.

Add the following to the drone configuration

```yml
kind: pipeline
name: default

steps:
  - name: semantic-release
    image: cenk1cenk2/drone-lerna
    settings:
      # arguments: -- # semantic release
      add_apk: # install apk packages for exec step of semantic release
      add_modules: # install node packages if desired
      git_method: gh # set for git authentication with gh (Github), gl (GitLab), bb (BitBucket), cr (Credentials)
      # arguments: -- # arguments for passing to the semantic-release
      git_user_name: bot # semantic release committer name (git config user.name), defaults to semantic-release
      git_user_email: bot@example.com # semantic release committer email (git config user.email)
      github_token: # semantic release token (for authentication)
        from_secret: github_token
      npm_token: # semantic release token (for authentication)
        from_secret: npm_token
```

or for BitBucket

```yml
bitbucket_token: # semantic release token (for authentication)
  from_secret: token
```

or for GitLab

```yml
gitlab_token: # semantic release token (for authentication)
  from_secret: token
```

or for any git server (including BitBucket cloud which does not support tokens):

```yml
git_login: bot
git_password:
  from_secret: password
```

## Custom Release File

You can overwrite the default configuration defined in `release.config.js` by adding `release.config.js` or `.releaserc` to your repository. But this can be overwritten by setting `use_local_rc` variable to `true`.

## What it does

Runs on master branch only. Skips any actions below while on other branches.

- Runs `lerna publish` has support for GIT for using semantic release.
