Some things to keep in mind:

 * The office's default network DNS settings ruin ChunkWM for some reason. Make sure to add 8.8.8.8 to the top of the DNS servers in the Network tab.
 * ChunkWM has some optional scripting extensions that are REALLY useful, but can only be installed without SIP protections. Use the [docs](https://koekeishiya.github.io/chunkwm/docs/sa.html) for more info on how to enable them.
 * Place the private SSH and GPG keys into `<projectRoot>/keys/private`.
 * Note that Weechat's `sec.conf` file is NOT watched for changes in Git, so any new keys mean that the file needs to be explicitly added
 * The Bitbar folder is expected to be `~/Documents/BitBar`.
