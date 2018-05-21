{ pkgs, config, lib, ... }:

let
  work-projects = {
    afra = [
      { repo = "apops";}
    ];
    aps = [
      { repo = "api-authentication-handler"; }
      { repo = "api-json-schema-provider"; }
      { repo = "aps-client"; }
      { repo = "aps-contacts"; }
      { repo = "aps-messages"; }
      { repo = "aps-push-notification"; }
      { repo = "aps-team-stats"; }
      { repo = "aps-util"; }
      { repo = "event-payload-injector"; }
      { repo = "house-on-fire"; }
      { repo = "message-client"; }
    ];
    chuck = [
      { repo = "dispatcher"; shell = "~/nix-shells/dispatcher/default.nix"; build = false; }
      { repo = "dispatcher-model"; shell = "~/nix-shells/php55/default.nix"; build = false; }
    ];
    com = [
      { repo = "email"; build = false; }
    ];
    ean = [
      { repo = "agent-phone-provisioning-service"; }
      { repo = "wiggum"; }
    ];
    lemmy = [
      { repo = "goodcop"; }
      { repo = "l2-functional-tests"; }
      { repo = "lead-model"; }
      { repo = "lead-model-serialization"; }
    ];
    npm = [
      { repo = "navbar"; }
    ];
    sup = [
      { repo = "account-migration"; }
      { repo = "agent-directory-scripts"; }
      { repo = "user-profile-api-client"; }
      { repo = "user-profile-service"; }
    ];
    tem = [
      { repo = "react-app-template"; }
    ];
    web = [
      { repo = "agentprofile"; build = false; }
      { repo = "agentweb"; build = false; }
      { repo = "code-quality-configs"; }
      { repo = "common"; build = false; }
      { repo = "salesforce"; build = false; }
      { repo = "web"; build = false; }
    ];
    zrm = [
      { repo = "agent-platform-core-clients"; }
      { repo = "agent-teams-utilities"; }
      { repo = "agent-teams"; shell = "~/nix-shells/php55/default.nix"; }
      { repo = "agenthub-api-client"; }
      { repo = "agentteamsproc"; }
      { repo = "autoresponder-service"; }
      { repo = "capi-server"; }
      { repo = "crm-data-entities"; }
      { repo = "crm-data-repository"; }
      { repo = "ean-client"; }
      { repo = "lead-forwarding-proc"; }
      { repo = "lead-routing-api"; }
      { repo = "leadrouting-data-repository"; }
      { repo = "leadrouting-handler"; }
      { repo = "leadrouting-lib"; }
      { repo = "nav-bundle"; }
      { repo = "notifications-panel"; }
      { repo = "paxl-react-pageheader"; }
      { repo = "paxl-react"; }
      { repo = "paxl"; }
      { repo = "polaris-bethid-api"; }
      { repo = "polaris-lead-events-proc"; }
      { repo = "polaris-to-beth-concierge-proc"; }
      { repo = "puppetmaster"; }
      { repo = "styleguide"; }
      { repo = "thread-data-repository"; }
      { repo = "trulia-featured-listings-api-client"; }
      { repo = "trulia-featured-listings-api"; }
      { repo = "video-message-template-provisioner"; }
      { repo = "video-message-template-service"; }
      { repo = "web-crm-frontend"; }
      { repo = "web-crm"; }
      { repo = "zillow-readiness-handler"; }
    ];
    "~tdoggett" = [
      { repo = "innovation_week_voter_client"; }
    ];
  };
in {
  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;

  home.file = {
    "bin/zg_startup_nix" = {
      text = ''
        #!/usr/bin/env bash

        # Remove listing of current zillow git repos
        if [ -e ${builtins.getEnv "HOME"}/.local/share/zillowgits ]; then
          rm ${builtins.getEnv "HOME"}/.local/share/zillowgits
        fi

        npm set progress false;
        '' +
        (
          lib.concatStrings (
            lib.mapAttrsToList ( namespace: projects:
              lib.concatMapStrings ( project:
                "${builtins.getEnv "HOME"}/${config.home.file."bin/zgitclone".target} "
                + (if lib.hasPrefix "~" namespace then "\"" else "") + "${namespace}" + (if lib.hasPrefix "~" namespace then "\"" else "")
                + " ${project.repo}"
                + (if lib.hasAttrByPath ["new-name"] project then " \"${project.new-name}\"" else ( if lib.hasAttrByPath ["build"] project then " ${project.repo}" else "") )
                + "${if lib.hasAttrByPath ["build"] project then (if project.build then "" else " false") else ""}"
                + "\n"
                + (
                  if lib.hasAttrByPath ["shell"] project then ''
                    if [ ! -f "${builtins.getEnv "ZILLOW"}/${builtins.replaceStrings ["~"] ["_"] namespace}/${if lib.hasAttrByPath ["new-name"] project then project.new-name else project.repo}/default.nix" ] ; then
                      cp "${project.shell}" "${builtins.getEnv "ZILLOW"}/${builtins.replaceStrings ["~"] ["_"] namespace}/${if lib.hasAttrByPath ["new-name"] project then project.new-name else project.repo}/default.nix"
                    fi
                  '' else ""
                )
              ) projects
            ) work-projects
          )
        )
        + ''
        npm set progress true
      '';
      executable = true;
    };
    "bin/zg_backup" = {
      text = ''
        #!/usr/bin/env bash
        projects="${builtins.getEnv "PROJECTS"}"
        zillow="${builtins.getEnv "ZILLOW"}"

        originaldir="$(pwd)"
        dest="$projects/backup";
        mkdir -p "$dest"
        cd "$dest"
        while IFS= read -r gitdir
        do
          if [ -d $gitdir ]; then
            subdir=${"$"}{gitdir//$zillow/}
            name=${"$"}{subdir//\//_}
            if [ -d $name ]; then
              rm -Rf $name
            fi
            git clone -q --bare $gitdir $name
            if [ -e $name.tar.gz ]; then
              rm -f $name.tar.gz $name.unstaged.patch $name.staged.patch
            fi
            tar -zcf $name.tar.gz $name && rm -Rf $name
            cd $gitdir
            if [[ $(git status --porcelain) ]]; then
              [[ $(git ls-files --others --exclude-standard) ]] && rm -Rf __untracked __untrackedFiles && \
                git ls-files --others --exclude-standard >> __untracked && mkdir __untrackedFiles && \
                rsync -qav --files-from=__untracked $(pwd) ./__untrackedFiles && \
                rm -f __untracked __untrackedFiles/__untracked && tar -zcf $dest/$name.untrackedFiles.tar.gz __untrackedFiles && rm -rf __untrackedFiles
              [[ $(git diff --binary) ]] && git diff --binary >> $dest/$name.unstaged.patch
              [[ $(git diff --cached --binary) ]] && git diff --cached --binary >> $dest/$name.staged.patch
            fi
            cd - > /dev/null;
          fi
        done < "${builtins.getEnv "HOME"}/.local/share/zillowgits"
        cd $originaldir > /dev/null;
      '';
      executable = true;
    };
    "bin/zgitclone" = {
      text = ''
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
      '';
      executable = true;
    };
    ".ideavimrc" = {
      text = ''
        filetype plugin indent on
        syntax enable
        set hidden
        set number
        set relativenumber
        autocmd InsertEnter * :set norelativenumber
        autocmd InsertLeave * :set relativenumber
        set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab
        colorscheme molokai
        let g:rehash256 = 1
        :imap jj <Esc>
      '';
      executable = false;
    };
    ".config/rtv/rtv.cfg" = {
      text = ''
        [rtv]
        ascii = False
        monochrome = False
        subreddit = front
        persistent = True
        clear_auth = False
        history_size = 200
        enable_media = True
        max_comment_cols = 120
        hide_username = False
        theme = solarzed-dark
        oauth_client_id = E2oEtRQfdfAfNQ
        oauth_client_secret = praw_gapfill
        oauth_redirect_uri = http://127.0.0.1:65000/
        oauth_redirect_port = 65000
        oauth_scope = edit,history,identity,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote
        imgur_client_id = 93396265f59dec9
        [bindings]
        EXIT = q 
        FORCE_EXIT = Q
        HELP = ?
        SORT_HOT = 1
        SORT_TOP = 2
        SORT_RISING = 3
        SORT_NEW = 4
        SORT_CONTROVERSIAL = 5
        MOVE_UP = k, <KEY_UP>
        MOVE_DOWN = j, <KEY_DOWN>
        PREVIOUS_THEME = <KEY_F2>
        NEXT_THEME = <KEY_F3>
        PAGE_UP = m, <KEY_PPAGE>, <NAK>
        PAGE_DOWN = n, <KEY_NPAGE>, <EOT>
        PAGE_TOP = gg
        PAGE_BOTTOM = G
        UPVOTE = a
        DOWNVOTE = z
        LOGIN = u
        DELETE = d
        EDIT = e
        INBOX = i
        REFRESH = r, <KEY_F5>
        PROMPT = /
        SAVE = w
        COPY_PERMALINK = y
        COPY_URL = Y
        SUBMISSION_TOGGLE_COMMENT = 0x20
        SUBMISSION_OPEN_IN_BROWSER = o, <LF>, <KEY_ENTER>
        SUBMISSION_POST = c
        SUBMISSION_EXIT = h, <KEY_LEFT>
        SUBMISSION_OPEN_IN_PAGER = l, <KEY_RIGHT>
        SUBMISSION_OPEN_IN_URLVIEWER = b
        SUBMISSION_GOTO_PARENT = K
        SUBMISSION_GOTO_SIBLING = J
        SUBREDDIT_SEARCH = f
        SUBREDDIT_POST = c
        SUBREDDIT_OPEN = l, <KEY_RIGHT>
        SUBREDDIT_OPEN_IN_BROWSER = o, <LF>, <KEY_ENTER>
        SUBREDDIT_OPEN_SUBSCRIPTIONS = s
        SUBREDDIT_OPEN_MULTIREDDITS = S
        SUBREDDIT_FRONTPAGE = p
        SUBSCRIPTION_SELECT = l, <LF>, <KEY_ENTER>, <KEY_RIGHT>
        SUBSCRIPTION_EXIT = h, s, S, <ESC>, <KEY_LEFT>
      '';
      executable = false;
    };
  };

  programs.git = {
    enable = true;
    userName = "Tom Doggett";
    userEmail = "nocoolnametom@gmail.com";
    signing = {
      # Note that this key needs to be imported to gpg!
      key = "5279843C73EB8029F9F6AF0EC4252D5677A319CA";
      signByDefault = true;
    };
    aliases = {
      co = "checkout";
    };
    extraConfig = {
      log = {
        decorate = "full";
      };
      rebase = {
        autostash = true;
      };
      pull = {
        rebase = true;
      };
      stash = {
        showPatch = true;
      };
      "color \"status\"" = {
        added = "green";
        changed = "yellow bold";
        untracked = "red bold";
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = [
      {
        host = "hassio.local";
        hostname = "hassio.local";
        identityFile = "~/.ssh/id_rsa";
        user = "root";
      }
      {
        host = "github.com";
        hostname = "github.com";
        identityFile = "~/.ssh/id_rsa";
        user = "git";
      }
      {
        host = "fedev";
        hostname = "fedevsv2.sv2.trulia.com";
        identityFile = "~/.ssh/id_rsa";
        user = "tdoggett";
      }
      {
        host = "stage.aws";
        hostname = "bastion.stage.ap.truaws.com";
        identityFile = "~/.ssh/mysqlaccess";
        user = "mysqlaccess";
      }
      {
        host = "remote_gollum";
        hostname = "home.nocoolnametom.com";
        identityFile = "~/.ssh/id_rsa";
        user = "pi";
        port = 22223;
      }
      {
        host = "remote_bill";
        hostname = "home.nocoolnametom.com";
        identityFile = "~/.ssh/id_rsa";
        user = "pi";
        port = 22224;
      }
      {
        host = "linode";
        hostname = "nocoolnametom.com";
        identityFile = "~/.ssh/id_rsa";
        user = "doggetto";
        port = 2222;
      }
      {
        host = "elrond";
        hostname = "45.33.53.132";
        identityFile = "~/.ssh/id_rsa";
        user = "tdoggett";
        port = 2222;
      }
      {
        host = "stash.sv2.trulia.com";
        hostname = "stash.sv2.trulia.com";
        identityFile = "~/.ssh/trulia_rsa";
        user = "git";
        port = 7999;
      }
      {
        host = "stash";
        hostname = "stash.sv2.trulia.com";
        identityFile = "~/.ssh/trulia_rsa";
        user = "git";
        port = 7999;
      }
      {
        host = "frodo";
        hostname = "frodo";
        identityFile = "~/.ssh/id_rsa";
        user = "pi";
      }
      {
        host = "bill";
        hostname = "bill";
        identityFile = "~/.ssh/id_rsa";
        user = "pi";
      }
      {
        host = "gollum";
        hostname = "gollum";
        identityFile = "~/.ssh/id_rsa";
        user = "pi";
      }
    ];
  };
}