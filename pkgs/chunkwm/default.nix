{ pkgs, stdenv, ... }:

with pkgs; recurseIntoAttrs (callPackage ./chunkwm {
  inherit (pkgs) callPackage stdenv fetchFromGitHub imagemagick;
  inherit (darwin.apple_sdk.frameworks) Carbon Cocoa ApplicationServices;
}) // (let
  chunkc = "${pkgs.mine.chunkwm.core}/bin/chunkc";
in {
  # Note that the current nix-darwin chunkwm module adds some references to `chunkc`
  # so until that changes, make sure you have the `core` package installed system-wide
  extraConfig = ''
    ${chunkc} core::log_file /tmp/chunkwmerr
    ${chunkc} core::log_level debug
  '';
  plugins = {
    dir = "/run/current-system/sw/bin/chunkwm-plugins/";
    list = ["border" "ffm" "tiling"];
    "border".config = ''
      ${chunkc} set focused_border_color          0xffc0b18b
      ${chunkc} set focused_border_width          4
      ${chunkc} set focused_border_radius         0
      ${chunkc} set focused_border_skip_floating  0
    '';
    "tiling".config = ''
      ${chunkc} set global_desktop_mode           bsp

      ${chunkc} set global_desktop_offset_top     10
      ${chunkc} set global_desktop_offset_bottom  10
      ${chunkc} set global_desktop_offset_left    10
      ${chunkc} set global_desktop_offset_right   10
      ${chunkc} set global_desktop_offset_gap     20

      ${chunkc} set desktop_padding_step_size     10.0
      ${chunkc} set desktop_gap_step_size         5.0

      ${chunkc} set bsp_spawn_left                1
      ${chunkc} set bsp_optimal_ratio             1.618
      ${chunkc} set bsp_split_mode                optimal
      ${chunkc} set bsp_split_ratio               0.66

      ${chunkc} set window_focus_cycle            monitor
      ${chunkc} set mouse_follows_focus           1
      ${chunkc} set window_float_next             0
      ${chunkc} set window_float_center           1
      ${chunkc} set window_region_locked          1
    '';
  };
})