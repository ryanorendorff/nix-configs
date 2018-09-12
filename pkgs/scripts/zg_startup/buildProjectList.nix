{ projectList, lib, pkgs, ... }:

(
  lib.concatStrings (
    lib.mapAttrsToList ( service: namespace:
      "\n# ${service} projects\n" +
      lib.concatStrings (
        lib.mapAttrsToList ( namespace: projects:
          lib.concatMapStrings ( project:
            "${pkgs.mine.scripts.zgitclone}"
            + (if service == "stash" then " -s" else "")
            + (if service == "bitbucket" then " -b" else "")
            + (if lib.hasAttrByPath ["shell"] project then " -N ${project.shell}" else "")
            + (if lib.hasAttrByPath ["new-name"] project then " -n \"${project.new-name}\"" else "")
            + (if lib.hasAttrByPath ["directory"] project then " -d \"${project.directory}\"" else "")
            + (if lib.hasAttrByPath ["build"] project then (if project.build then "" else " --no-build") else "")
            + " --make-shell=$SHOULD_BUILD"
            + (if lib.hasPrefix "~" namespace then " \"" else " ") + "${namespace}" + (if lib.hasPrefix "~" namespace then "\"" else "")
            + " ${project.repo}"
            + "\n"
          ) projects
        ) namespace
      )
    ) projectList
  )
)