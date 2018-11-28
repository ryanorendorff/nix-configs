# Private Keys

## Keys and similar files that are referenced and must be here:

 * `credentials.json`
   * Google App authentication credentials
   * This file is downloaded via the [Quickstart][google_api_quickstart] instructions.
 * `id_rsa`
   * This is your personal private key
 * `mysqlaccess`
   * This is the stage db private key for tunnelling
 * `stage-apops`
   * This is another stage db private key for tunnelling
 * `token.json`
   * Google App authentication token
   * This file is created by running the example script at the Google [Quickstart][google_api_quickstart] instructions.
 * `trulia_rsa`
   * This is your work private key

## Nix String Files

I'm also currently storing secrets (API keys, namespaces, etc) in this directory.  These are all simply the given key in double-quotes (thus a string value when evaluated by Nix).

```nix
# example.nix
"1d7b64b05c8fa771fa04afe0854a913e"
```
 * `google_mopidy_key.nix`
   * My app password for connecting mopidy to Google Music
 * `jenkins_api_key.nix`
   * My API key for the agent platform Jenkins server
 * `longview_api_key.nix`
   * My API key for the elrond Linode server
 * `openweathermap_key.nix`
   * My API key for OpenWeatherMap
 * `todoist_key.nix`
   * My API key for Todoist


[google_api_quickstart]: https://developers.google.com/calendar/quickstart/nodejs
