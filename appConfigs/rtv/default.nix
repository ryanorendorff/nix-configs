{ lib, pkgs, ... }:

let rtvConfig = {
  rtv = {
    ascii = false;
    monochrome = false;
    subreddit = "front";
    persistent = true;
    clear_auth = false;
    history_size = 200;
    enable_media = true;
    max_comment_cols = 120;
    hide_username = false;
    theme = "solarized-dark";
    oauth_client_id = "E2oEtRQfdfAfNQ";
    oauth_client_secret = "praw_gapfill";
    oauth_redirect_uri = http://127.0.0.1:65000/;
    oauth_redirect_port = 65000;
    oauth_scope = "edit,history,identity,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote";
    imgur_client_id = "93396265f59dec9";
  };
  bindings = {
    EXIT = "q";
    FORCE_EXIT = "Q";
    HELP = "?";
    SORT_HOT = 1;
    SORT_TOP = 2;
    SORT_RISING = 3;
    SORT_NEW = 4;
    SORT_CONTROVERSIAL = 5;
    MOVE_UP = "k, <KEY_UP>";
    MOVE_DOWN = "j, <KEY_DOWN>";
    PREVIOUS_THEME = "<KEY_F2>";
    NEXT_THEME = "<KEY_F3>";
    PAGE_UP = "m, <KEY_PPAGE>, <NAK>";
    PAGE_DOWN = "n, <KEY_NPAGE>, <EOT>";
    PAGE_TOP = "gg";
    PAGE_BOTTOM = "G";
    UPVOTE = "a";
    DOWNVOTE = "z";
    LOGIN = "u";
    DELETE = "d";
    EDIT = "e";
    INBOX = "i";
    REFRESH = "r, <KEY_F5>";
    PROMPT = "/";
    SAVE = "w";
    COPY_PERMALINK = "y";
    COPY_URL = "Y";
    SUBMISSION_TOGGLE_COMMENT = "0x20";
    SUBMISSION_OPEN_IN_BROWSER = "o, <LF>, <KEY_ENTER>";
    SUBMISSION_POST = "c";
    SUBMISSION_EXIT = "h, <KEY_LEFT>";
    SUBMISSION_OPEN_IN_PAGER = "l, <KEY_RIGHT>";
    SUBMISSION_OPEN_IN_URLVIEWER = "b";
    SUBMISSION_GOTO_PARENT = "K";
    SUBMISSION_GOTO_SIBLING = "J";
    SUBREDDIT_SEARCH = "f";
    SUBREDDIT_POST = "c";
    SUBREDDIT_OPEN = "l, <KEY_RIGHT>";
    SUBREDDIT_OPEN_IN_BROWSER = "o, <LF>, <KEY_ENTER>";
    SUBREDDIT_OPEN_SUBSCRIPTIONS = "s";
    SUBREDDIT_OPEN_MULTIREDDITS = "S";
    SUBREDDIT_FRONTPAGE = "p";
    SUBSCRIPTION_SELECT = "l, <LF>, <KEY_ENTER>, <KEY_RIGHT>";
    SUBSCRIPTION_EXIT = "h, s, S, <ESC>, <KEY_LEFT>";
  };
}; in pkgs.writeText "rtv.cfg" (
  lib.concatStrings (
    lib.flatten (
      lib.mapAttrsToList (
        section: values: (
          [ "[${section}]\n" ] ++
          lib.mapAttrsToList (
            name: value: "${name} = " + (
              if lib.isBool value
              then (if value then "True" else "False")
              else toString value
            ) + "\n"
          ) values
        )
      ) rtvConfig
    )
  )
)