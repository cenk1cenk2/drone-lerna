#!/bin/bash

export GIT_LOGIN=${PLUGIN_GIT_LOGIN:-$PLUGIN_GIT_USER_EMAIL}
export PLUGIN_GIT_USER_NAME=${PLUGIN_GIT_USER_NAME:-"semantic-release"}
export GIT_AUTHOR_NAME=$PLUGIN_GIT_USER_NAME
export GIT_AUTHOR_EMAIL=$PLUGIN_GIT_USER_EMAIL
export GIT_COMMITTER_NAME=$PLUGIN_GIT_USER_NAME
export GIT_COMMITTER_EMAIL=$PLUGIN_GIT_USER_EMAIL
export NPM_TOKEN=$PLUGIN_NPM_TOKEN
export ADD_MODULES=$PLUGIN_ADD_MODULES
export ADD_APK=$PLUGIN_ADD_APK

create_git_credentials() {
  # check git method elsewise it was causing problems
  if [ -z $PLUGIN_GIT_METHOD ]; then
    echo "Variable git_method must be set in settings."
    exit 1
  fi

  # create credentials for login
  if [ "$PLUGIN_GIT_METHOD" == "gh" ]; then
    export GH_TOKEN=$PLUGIN_GITHUB_TOKEN
    export GIT_PASSWORD=$PLUGIN_GITHUB_TOKEN
  elif [ "$PLUGIN_GIT_METHOD" == "gl" ]; then
    export GL_TOKEN=$PLUGIN_GITLAB_TOKEN
    export GIT_PASSWORD=$PLUGIN_GITLAB_TOKEN
  elif [ "$PLUGIN_GIT_METHOD" == "bb" ]; then
    export BB_TOKEN=$PLUGIN_BITBUCKET_TOKEN
    export GIT_PASSWORD=$PLUGIN_BITBUCKET_TOKEN
  elif [ "$PLUGIN_GIT_METHOD" == "cr" ]; then
    export GIT_CREDENTIALS=$(node /release/create-credentials.js)
  else
    echo "Variable git_method must be one of the following: gh (Github), gl (GitLab), bb (BitBucket), cr (Credentials)"
    exit 1
  fi

  # define the user
  if [ -z "$PLUGIN_GIT_USER_NAME" ]; then
    echo "GIT Username not defined! Please set git_user_name in Drone plugin settings."
    exit 127
  elif [ -z "$PLUGIN_GIT_USER_EMAIL" ]; then
    echo "GIT E-Mail not defined! Please set git_user_email in Drone plugin settings."
    exit 127
  fi

  # Set git variables
  git config --global user.name "$GIT_COMMITTER_NAME"
  git config --global user.email "$GIT_COMMITTER_EMAIL"
  git config --global credential.helper store

  # login with credentials
  git config --global credential.helper "!f() { echo 'username=${GIT_LOGIN}'; echo 'password=${GIT_PASSWORD}'; }; f"
}

create_git_credentials

(cd /drone/src && lerna publish -y)
