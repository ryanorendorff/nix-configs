#!/usr/bin/env bash
export ME="nocoolnametom@gmail.com"
insync start && insync pause_syncing && insync move_folder "~/$ME" ~/google_drive && insync manage_selective_sync $ME && insync resume_syncing && sleep 30 && cat "Open keepassxc for keybase password!" &&
keybase login &&
gpg --import ~/keybase/private/nocoolnametom/keys/keybase_secret.asc &&
gpg --change-passphrase 5279843C73EB8029F9F6AF0EC4252D5677A319CA &&
nix-shell -p "expect" --command "expect -c 'set timeout 10; spawn gpg --edit-key 5279843C73EB8029F9F6AF0EC4252D5677A319CA 0 --yes trust quit; expect \"Your decision? \" { send \"5\r\" }; expect \"Do you really want to set this key to ultimate trust? \(y/N\) \" { send \"y\r\" }; interact;'" &&
gcalcli agenda --noauth_local_webserver