{ pkgs, mkI3blockContribScript, ... }:

mkI3blockContribScript {
  scriptName = "mediaplayer";
  buildDeps =  [ pkgs.perl ];
}