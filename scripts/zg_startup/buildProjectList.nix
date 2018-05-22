{ zgitclone, projectList, lib, ... }:

(
  lib.concatStrings (
    lib.mapAttrsToList ( namespace: projects:
      lib.concatMapStrings ( project:
        "${zgitclone} "
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
    ) projectList
  )
)