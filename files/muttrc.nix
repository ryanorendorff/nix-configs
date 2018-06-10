{ pkgs, config, ...}:

let
  vim = if pkgs.stdenv.isDarwin then pkgs.vim else config.programs.vim.package;
in ''
  bind editor <space> noop
  set edit_headers

  set editor        = "${vim}/bin/vim +/^$ ++1"
  set folder        = imaps://outlook.office365.com:993/
  set hostname      = "zillowgroup.com"
  set imap_user     = tdoggett@zillowgroup.com
  # Password not stored so it is asked for on startup
  #set imap_pass    = "foobar"
  set spoolfile     = +INBOX
  set ssl_starttls  = yes
  set ssl_force_tls = yes
  mailboxes =INBOX
  set imap_check_subscribed

  set header_cache = ~/.cache/mutt
  set message_cachedir = "~/.cache/mutt"

  macro index,pager y ":set confirmappend=no resolve=no\n<clear-flag>N<tag-prefix><save-message>=Archive\n:set confirmappend=yes resolve=yes\n<next-undeleted>" "Archive"

  # Allow Mutt to open new imap connection automatically.
  unset imap_passive

  # Keep IMAP connection alive by polling intermittently (time in seconds).
  set imap_keepalive = 120
  set imap_idle      = yes

  # How often to check for new mail (time in seconds).
  set mail_check = 60
  set timeout    = 180

  set sidebar_visible = yes

  set sidebar_width = 20

  set sidebar_short_path = no

  # When abbreviating mailbox path names, use any of these characters as path
  # separators.  Only the part after the last separators will be shown.
  # For file folders '/' is good.  For IMAP folders, often '.' is useful.
  set sidebar_delim_chars = '/.'

  # If the mailbox path is abbreviated, should it be indented?
  set sidebar_folder_indent = no

  # Indent mailbox paths with this string.
  set sidebar_indent_string = '  '

  # Make the Sidebar only display mailboxes that contain new, or flagged,
  # mail.
  set sidebar_new_mail_only = yes

  # Any mailboxes that are whitelisted will always be visible, even if the
  # sidebar_new_mail_only option is enabled.
  # sidebar_whitelist '/home/user/mailbox1'

  # When searching for mailboxes containing new mail, should the search wrap
  # around when it reaches the end of the list?
  set sidebar_next_new_wrap = no

  # The character to use as the divider between the Sidebar and the other Mutt
  # panels.
  # Note: Only the first character of this string is used.
  set sidebar_divider_char = '|'

  # Enable extended buffy mode to calculate total, new, and flagged
  # message counts for each mailbox.
  set mail_check_stats

  # Display the Sidebar mailboxes using this format string.
  set sidebar_format = '%B%?F? [%F]?%* %?N?%N/?%S'

  # Sort the mailboxes in the Sidebar using this method:
  #       count    - total number of messages
  #       flagged  - number of flagged messages
  #       new      - number of new messages
  #       path     - mailbox path
  #       unsorted - do not sort the mailboxes
  set sidebar_sort_method = 'unsorted'

  # Move the highlight to the previous mailbox
  bind index,pager \Cp sidebar-prev

  # Move the highlight to the next mailbox
  bind index,pager \Cn sidebar-next

  # Open the highlighted mailbox
  bind index,pager \Co sidebar-open

  bind index,pager \Cv view-raw-message

  # Move the highlight to the previous page
  # This is useful if you have a LOT of mailboxes.
  bind index,pager <F3> sidebar-page-up

  # Move the highlight to the next page
  # This is useful if you have a LOT of mailboxes.
  bind index,pager <F4> sidebar-page-down

  # Move the highlight to the previous mailbox containing new, or flagged,
  # mail.
  bind index,pager <F5> sidebar-prev-new

  # Move the highlight to the next mailbox containing new, or flagged, mail.
  bind index,pager <F6> sidebar-next-new

  # Toggle the visibility of the Sidebar.
  bind index,pager B sidebar-toggle-visible

  # Prefer plain-text to HTML emails
  alternative_order text/plain text/enriched text/html
  auto_view text/html

  # Colors
  color hdrdefault cyan default
  color attachment yellow default

  color header brightyellow default "From: "
  color header brightyellow default "Subject: "
  color header brightyellow default "Date: "

  color quoted green default
  color quoted1 cyan default
  color quoted2 green default
  color quoted3 cyan default

  color error     red             default         # error messages
  color message   white           default         # message  informational messages
  color indicator white           red             # indicator for the "current message"
  color status    white           blue            # status lines in the folder index sed for the mini-help line
  color tree      red             default         # the "tree" display of threads within the folder index
  color search    white           blue            # search matches found with search within the internal pager
  color markers   red             default         # The markers indicate a wrapped line hen showing messages with looong lines

  color index     yellow default  '~O'
  color index     yellow default  '~N'
  color index     brightred       default '~F'    # Flagged Messages are important!
  color index     blue default    '~D'            # Deleted Mails - use dark color as these are already "dealt with"
''