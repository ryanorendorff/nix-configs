{ pkgs, lib, ...}:

pkgs.writeScript "personal_repos" (
  ''
    #!/usr/bin/env bash

    export SHOULD_BUILD=0

    script="${"$"}{0##*/}"
    while test $# -gt 0; do
    case "$1" in
      -h|--help)
        echo "$script - Build the entire personal project ecosystem"
        echo " "
        echo "$script [options]"
        echo " "
        echo "options:"
        echo "-h, --help       show brief help"
        echo "--build-shells   build all applicable Nix shells"
        exit 0
        ;;
      --build-shells*)
        export SHOULD_BUILD=1
        shift
        ;;
      *)
        break
        ;;
      esac
    done

    export URLS_ACTIVE=0 && ping -q -w1 -c1 github.com &>/dev/null && export URLS_ACTIVE=1

    if [ $URLS_ACTIVE -eq 1 ]; then

    # Remove listing of current personal git repos
    if [ -e ${builtins.getEnv "HOME"}/.local/share/personalgits ]; then
      rm ${builtins.getEnv "HOME"}/.local/share/personalgits
    fi
  ''
  + ( import ./buildProjectList.nix {
    inherit lib;
    inherit pkgs;
    projectList = import ../../../personalProjectList;
  } ) + "\nfi"
)
