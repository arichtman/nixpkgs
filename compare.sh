#!/bin/bash
LAST_VERSION=0.54.0
PACKAGE=terragrunt

# CURRENT_VERSION=$(nix eval --raw .#terragrunt.version)
# COMPARISON=$(nix eval --expr " builtins.compareVersions \"${LAST_VERSION}\" \"${CURRENT_VERSION}\"")
# [ $COMPARISON -eq -1 ];

get_current_version(){
  nix eval --raw ".#${1}.version";
}

is_current_newer() {
  local CURRENT=$(get_current_version "${PACKAGE}")
  local COMPARISON=$(nix eval --expr " builtins.compareVersions \"${1}\" \"${CURRENT}\"")
  [ $COMPARISON -eq -1 ];
}

get_current_commit_hash(){
  git log --format=format:"%H" --no-patch -1 ;
}

get_first_commit_hash(){
  # git log --format=format:"%H" --no-patch --reverse | head -1 ;
  git log -1000 --format=format:%H | tail -r | head -1 ;
}
export -f get_first_commit_hash

# exit 0
git bisect start
# I think bad/new aren't hanging it's just processing 55k+ commits
# I think we can skip getting current commit hash
# git bisect good $(get_first_commit_hash)
# git bisect bad $(get_current_commit_hash)
git bisect old $(get_first_commit_hash)
git bisect new $(get_current_commit_hash)
git bisect run is_current_newer "${LAST_VERSION}"
# git tag "${PACKAGE}-$(get_current_version)"
