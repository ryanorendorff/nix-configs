{...}:

''
  #!/usr/bin/env bash
  dir=${"$"}{1//\~/_}
  mkdir -p "${builtins.getEnv "ZILLOW"}/$dir"
  cd "${builtins.getEnv "ZILLOW"}/$dir"
  if [[ $# -eq 0 || $# -eq 1 ]]; then
    script="${"$"}{0##*/}"
    echo "Usage: $script teamName projectName [localDirectoryName]"
    exit 0
  fi
  if [ $# -eq 2 ] ; then
    if [ ! -d "${builtins.getEnv "ZILLOW"}/$dir/$2" ] ; then
      git clone "ssh://stash.sv2.trulia.com/$1/$2.git" "$2"
    fi
    if [ ! -d "${builtins.getEnv "ZILLOW"}/$dir/$2/.git" ] ; then
      exit
    fi
    echo "${builtins.getEnv "ZILLOW"}/$dir/$2" >> "${builtins.getEnv "HOME"}/.local/share/zillowgits"
    cd "${builtins.getEnv "ZILLOW"}/$dir/$2"
    git remote set-url --push origin "ssh://stash.sv2.trulia.com/~tdoggett/$2.git"
  else
    if [ ! -d "${builtins.getEnv "ZILLOW"}/$dir/$3" ] ; then
      git clone "ssh://stash.sv2.trulia.com/$1/$2.git" "$3"
    fi
    if [ ! -d "${builtins.getEnv "ZILLOW"}/$dir/$3/.git" ] ; then
      exit
    else
      echo "${builtins.getEnv "ZILLOW"}/$dir/$3/.git"
    fi
    echo "${builtins.getEnv "ZILLOW"}/$dir/$3" >> "${builtins.getEnv "HOME"}/.local/share/zillowgits"
    cd "${builtins.getEnv "ZILLOW"}/$dir/$3"
    git remote set-url --push origin "ssh://stash.sv2.trulia.com/~tdoggett/$3.git"
  fi
  git config user.name "Tom Doggett"
  git config user.email "tdoggett@zillowgroup.com"
  if [[ -e default.nix && ! `git ls-files -o | grep default.nix` ]] ; then
    git update-index --skip-worktree default.nix
  fi
  mkdir -p .git/info && touch .git/info/exclude && echo "default.nix" >> .git/info/exclude
  if [[ ! $# -eq 4 && -e package.json && ! -d node_modules ]] ; then
    npm install
  fi
  if [[ ! $# -eq 4 && -e composer.json && ! -d vendor ]] ; then
    composer install -n -q
  fi
''