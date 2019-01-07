# This is just a super-simple overlay to prevent Vim from using a GUI in MacOS
self: super: {
  vim_configurable = if super.stdenv.isDarwin then super.vim_configurable.override {
    guiSupport = "no";
  } else super.vim_configurable;
}
