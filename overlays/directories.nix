# This is just a super-simple overlay to prevent Vim from using a GUI in MacOS
self: super: let
  makeHome = username: "${if super.stdenv.isDarwin then "/Users" else "/home"}/" + username;
  makeProjects = username: (makeHome username) + "/" + (if super.stdenv.isDarwin then "Projects" else "projects");
in {
  my = rec {
    username = "tdoggett";
    directories = rec {
      home = makeHome username;
      projects = makeProjects username;
      zillow = projects + "/zillow";
      nixConfigsRepo = projects + "nocoolnametom/nix-configs";
    };
  };
}
