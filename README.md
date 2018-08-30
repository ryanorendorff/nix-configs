# Tom's Nix Configs

A unified collection of configurations for all of my Nix-based machines.

This repo is really only for my own personal use, but since I know people are looking at it for help with Nix or organizational ideas, I'm expanding this README to hopefully help them and myself when I have to start over with a new machine in the future.

## Installing

This is based around the fact that Nix imports respect symlinks.  In other words, when you reference a file within Nix with a relative path (`../foo/bar.nix`) it will do some from the real location of the file making the import. As such, you can symlink such essential files as `configuration.nix` or `config.nix` to their expected locations and all of their relative imports respect their real locations.

So to symlink this repo's NixOS `configuration.nix` file to it's intended location of `/etc/nixos/` you can create the symlink manually, or just run:

```console
$ sudo ./init_root.sh # Must be run as root!
```

To set up the `tdoggett` user-based config and home-manager system just run;

```#console
$ ./init.sh#
```

Using the init files are preferable, because we can also do more than just set up Nix config files.
## Basic Config Files

* `configuration.nix`
  * This file handles the configuration for my NixOS machines (currently these are all VMs)
* `darwin-configuration.nix`
  * This file handles the configuration for my MacOS work machine, which uses [nix-darwin][nix-darwin repo] to handle a number of system-wide settings for me in a NixOS-like fashion (ie, `/etc/hosts`, session variables, [ChunkWM][chunkwm repo], etc).
* `home.nix`
  * This file handles my user-level settings, including a large amount of my dotfile configuration. On Linux, it handles installing programs that relate more to my own personal user that just don't feel right placing within the system-wide `configuration.nix` file.
* `config.nix`
  * This file configures the behavior of the regular `nix` command for my local user.

## Overlays

I currently use overlays to add large groups of namespaced packages to be used by the configuration files.  It's a bit hacky and more a way to emulate a global system of packages instead of creating functions to pass these packages down where they may be required.

The overlays can be found within: `appConfigs`, `cronJobs` (namespaced to `myCronJobs`), `files` (`myFiles`), and most importantly `pkgs` (`mine`).

Most of the directories within the project employ the use of a specialized `default.nix` file to add packages without having to explicitly reference them:

```nix
{ pkgs, lib ? pkgs.lib, debug ? false, ... }:

with lib;

mapAttrs' (name: type: {
  name = removeSuffix ".nix" name;
  value = let file = ./. + "/${name}"; in
  lib.callPackageWith (pkgs // {
    inherit debug;
  }) file {};
}) (filterAttrs (name: type:
  (type == "directory" && builtins.pathExists "${toString ./.}/${name}/default.nix") ||
  (type == "regular" && hasSuffix ".nix" name && ! (name == "default.nix") && ! (name == "overlays.nix"))
) (builtins.readDir ./.))
```

This means that a file named `./foobarDirectory/default.nix` will be added to the resulting object under the attribute name of `foobarDirectory`, and a file that is sibling to this `default.nix` file named `./foobarFilename.nix` becomes the attribue `foobarFilename`.  This helps to quickly construct a tree of packages without a lot of boilerplate `import` or `callPackage` method calls.

## Directory Descriptions

### `appConfigs`

As much as possible, this directory contains configuration file text, or the values used by various Home Manager or Nix-Darwin modules to constuct configuration files, for various programs.

### `cronJobs`

This directory contains simple cron job descriptions.  Currently, these are only used by the NixOS `configuration.nix` config file.

### `files`

This directory contains information to be used in constructing files within the filesystem by the various tools.  `configuration.nix` and `darwin-configuration.nix` can build files within the `/etc` directory, and Home Manager's `home.nix` can build files within the home directory.

Most of these file descriptions point to other packages throughout the configuration (ie, a configuration file defined within `appConfig` is actually assigned to a filesystem location by a package within `files` that references it).

### `installList`

This is the list of programs to be installed by the system-management configuration files (not the user-level programs installed via `home.nix`). It is a simple list that uses `stdenv.isDarwin` and `stdenv.isLinux` to build the list of programs to be installed on the system.

### `keys`

My public and private keys are located here, as well as specific passwords or API keys.  Well, obviously not stored within the repo.  You'll find a list of the specific files that will need to be placed within `keys/private/`.  Without their presence you won't be able to execute any config commands because these files are `import`ed by name throughout the repo.

### `mutableDotfiles`

This is the only non-Nix section of the repo.  I was sick and tired of having two repos for dotfiles: one for my Home Manager config and the other for `stow` files.  So I moved all of the remaining dotfiles not easily managed through Home Manager into this directory.  Eventually this will go away I hope.  I have a bit of a hack in Home Manager to run `stow` on these files as part of switching generations so I don't need to run two different tools.

### `nixops`

This will hopefully begin storing NixOps configurations for my deployed AWS and Linode machines; this way it'll be easy to provide access to my keys, my personal packages, and my app configurations to the environment definitions of these machines.

### `nixos`

This is the rest of the NixOS configuration files, isolated from the main `configuration.nix` so that one day I'll be able to use NixOps to virtualize my default NixOS environment and test before making any actual changes. Or perhaps even manage NixOS through NixOps instead of `nixos-rebuild`.

### `overlays`

A simple function that assembles all of the overlays for easy use elsewhere.

### `pkgs`

All of my custom packages. This directory tree is similar to `nixpkgs` but I fully admit it's still pretty chaotic. In the future this will probably be spun out to one or more [NURs][nur repo].

### `pkgs/scripts/`

This is where I've placed many of the shell scripts I employ for checking out work repos, syncing local work repos to my Google Drive backup, and running my i3 Linux environment.

### `sessionVariables`

This holds the environmental session variables for my machines. It's not currently working for my MacOS machines.

### `shells`

This holds the `nix-shell` files for all of my work development environments. These are referenced by the `workProjectList`.

### `sshConfig`

This would be stored within the `appConfig`, but I like having SSH data being isolated to itself as it's so central to my systems.

### `workProjectList`

This is specific to my work, but this is a description of all of the repos I use at work with their Project namespaces, whether or not to run build commands after first instantiating them, and what shell files to use for them.  It makes extensive use of the `zgitclone` bash script defined in `pkgs/scripts/`.

## Some things to keep in mind:

 * The office's default network DNS settings ruin ChunkWM for some reason. If it won't start, `chunkc` can't connect, or it seems frozen, then try turning off all network connections and logout and login again. 
 * ChunkWM has some optional scripting extensions that are REALLY useful, but can only be installed without SIP protections. Use the [docs](https://koekeishiya.github.io/chunkwm/docs/sa.html) for more info on how to enable them.
 * Place the private SSH and GPG keys into `<projectRoot>/keys/private`!
 * Note that Weechat's `sec.conf` file is NOT watched for changes in Git, so any new keys mean that the file needs to be explicitly added
 * The Bitbar folder is expected to be `~/Documents/BitBar`.

[nix-darwin repo]: https://github.com/LnL7/nix-darwin
[chunkwm repo]: https://github.com/koekeishiya/chunkwm
[nur repo]: https://github.com/nix-community/NUR
