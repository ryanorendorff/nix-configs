{ pkgs, lib ? pkgs.lib, ... }:

{
  after = after: data: {
    inherit data after;
    before = [];
  };
  anywhere = data: {
    inherit data;
    before = [];
    after = [];
  };
}
