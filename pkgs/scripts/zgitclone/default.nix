{ pkgs, ... }:

pkgs.writeScript "zgitclone" (
  let
    nixpkgsChannel = "nixpkgs-unstable";
    myhome = if pkgs.stdenv.isDarwin then "/Users/tdoggett" else "/home/tdoggett";
    projects = if pkgs.stdenv.isDarwin then "${myhome}/Projects" else "${myhome}/projects";
    zillow = "${projects}/zillow";
  in ''
    #!/usr/bin/env bash
    export DIR=""
    export NAME=""
    export SHOULD_BUILD=1
    export NIX_SHELL=""
    export MAKE_SHELL=0
    # Default service is Stash
    export USE_STASH=1
    export USE_GITLAB=0
    script="${"$"}{0##*/}"
    while test $# -gt 0; do
    case "$1" in
      -h|--help)
        echo "$script - Clone a Zillow git project"
        echo " "
        echo "$script [options] teamName projectName"
        echo " "
        echo "options:"
        echo "-h, --help                show brief help"
        echo "-s, --stash               use Stash as the remote service [default]"
        echo "-b, --gitlab              use Gitlab as the remote service"
        echo "-n, --name=NAME           specify the directory name (default is projectName)"
        echo "-d, --output-dir=DIR      specify an absolute directory path (default is $ZILLOW/<teamName>/<projectName>)"
        echo "--no-build                do not run automatic dependency building"
        echo "-N, --nix-shell=<path>    path to a nix file to copy as shell.nix"
        echo "--make-shell=[0,1]        whether or not to build the shell environment"
        exit 0
        ;;
      -s|--stash)
        export USE_STASH=1
        export USE_GITLAB=0
        shift
        ;;
      -b|--gitlab)
        export USE_STASH=0
        export USE_GITLAB=1
        shift
        ;;
      -n)
        shift
        if test $# -gt 0; then
          export NAME="$1"
        else
          echo "no name specified"
          exit 1
        fi
        shift
        ;;
      --name*)
        export NAME=`echo $1 | sed -e 's/^[^=]*=//g'`
        shift
        ;;
      -d)
        shift
        if test $# -gt 0; then
          export DIR="$1"
        else
          echo "no directory path specified"
          exit 1
        fi
        shift
        ;;
      --output-dir*)
        export DIR=`echo $1 | sed -e 's/^[^=]*=//g'`
        shift
        ;;
      --no-build*)
        export SHOULD_BUILD=0
        shift
        ;;
      -N)
        shift
        if test $# -gt 0; then
          export NIX_SHELL="$1"
        else
          echo "no nix file specified"
          exit 1
        fi
        shift
        ;;
      --nix-shell*)
        export NIX_SHELL=`echo $1 | sed -e 's/^[^=]*=//g'`
        shift
        ;;
      --make-shell*)
        export MAKE_SHELL=`echo $1 | sed -e 's/^[^=]*=//g'`
        shift
        ;;
      *)
        break
        ;;
      esac
    done

    export STASH_TEAM_NAME=$1
    export STASH_PROJECT_NAME=$2
    export TEAM_NAME=${"$"}{STASH_TEAM_NAME//\~/_}
    export PROJECT_NAME=${"$"}{STASH_PROJECT_NAME//\~/_}
    if [[ -z "$NAME" ]] ; then
      export NAME="$PROJECT_NAME"
    fi

    if [[ $USE_STASH -eq 1 ]] ; then
      export SERVICE_HOST="stash"
      export MY_SERVICE_PATH="$SERVICE_HOST:~tdoggett"
    fi
    if [[ $USE_GITLAB -eq 1 ]] ; then
      export SERVICE_HOST="gitlab-zillow"
      export MY_SERVICE_PATH="$SERVICE_HOST:tdoggett"
    fi

    if [[ ! -z "$NIX_SHELL" && ${"$"}{NIX_SHELL: -4} != ".nix" ]] ; then
      export NIX_SHELL="$NIX_SHELL/default.nix"
    fi

    if [[ ! -z "$NIX_SHELL" && ! -e "$NIX_SHELL" ]] ; then
      export NIX_SHELL=""
    fi

    if [[ $# -eq 0 || $# -eq 1 ]] ; then
      script="${"$"}{0##*/}"
      echo "Missing teamName and/or projectName"
      $script --help
      exit 0
    fi

    if [[ -z "$DIR" ]] ; then
      export DIR="${zillow}/$TEAM_NAME/$NAME"
    fi

    if [ ! -d "$DIR" ] ; then
      mkdir -p "$DIR"
      git clone -q --recurse-submodules "$SERVICE_HOST:$STASH_TEAM_NAME/$STASH_PROJECT_NAME.git" "$DIR"
    fi
    if [ ! -d "$DIR/.git" ] ; then
      exit
    fi

    mkdir -p "${myhome}/.local/share"
    echo "$DIR" >> "${myhome}/.local/share/zillowgits"

    cd "$DIR"

    git remote set-url --push origin "$MY_SERVICE_PATH/$PROJECT_NAME.git"
    git config user.name "Tom Doggett"
    git config user.email "tdoggett@zillowgroup.com"

    if [[ ! -z "$NIX_SHELL" && -e "$NIX_SHELL" && ! -e ./shell.nix ]]; then
      cp "$NIX_SHELL" ./shell.nix
      latestHash=`git ls-remote git://github.com/NixOS/nixpkgs-channels.git | grep refs/heads/${nixpkgsChannel} | cut -f 1`
      sed -i.bak "s~<nixpkgs>~(fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/$latestHash.tar.gz)~" shell.nix && rm -f shell.nix.bak
      sed -i.bak "s~my_overlay = import.*;~my_overlay = import ${toString ../../overlays.nix};~" shell.nix && rm -f shell.nix.bak
      if [[ ! `git ls-files -o | grep shell.nix` ]] ; then
        git update-index --skip-worktree shell.nix
      fi
    fi

    mkdir -p .git/info && touch .git/info/exclude && [[ ! `grep "^shell.nix$" .git/info/exclude`  ]] && echo "shell.nix" >> .git/info/exclude

    if [[ $SHOULD_BUILD -eq 1 ]] ; then
      if [[ ! -z "$NIX_SHELL" ]] ; then
        if [[ $MAKE_SHELL -eq 1 ]] ; then
          nix-shell --pure --command ":"
        fi

        if [[ -e package.json && ! -d node_modules ]] ; then
          nix-shell --pure --command "npm install --progress=false --silent --quiet > /dev/null 2>&1"
        fi

        if [[ -e composer.json && ! -d vendor ]] ; then
          nix-shell --pure --command "composer install -n -q"
        fi
      else
        if [[ -e package.json && ! -d node_modules ]] ; then
          ${pkgs.nodejs}/bin/npm install --progress=false --silent --quiet > /dev/null 2>&1
        fi

        if [[ -e composer.json && ! -d vendor ]] ; then
          ${pkgs.phpPackages.composer}/bin/composer install -n -q
        fi
      fi
    fi

    cd - > /dev/null;
  ''
)
