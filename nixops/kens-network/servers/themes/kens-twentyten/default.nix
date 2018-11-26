{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, ... }:

stdenv.mkDerivation rec {
  version = "2.5";
  gAnalytics = "UA-37685907-1";
  themeName = "twentyten";
  name = "kens-${themeName}-theme-${version}";
  src = pkgs.fetchurl {
    url = "https://downloads.wordpress.org/theme/${themeName}.${version}.zip";
    sha256 = "1fiz799nswm2dxi7r2yl0k3nzckrqznw8skh68jsf3dsqyq6q6mx";
  };
  meta = {
    description = "Wordpress Twenty-Ten Theme with Ken's Alterations";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
  # We need unzip to build this package
  buildInputs = [ pkgs.unzip ];
  loopSingleSearch = "editedByAddendum";
  loopSingleText = builtins.replaceStrings ["$"] ["\\$"] ''
    <?php
      $post_ID = get_the_ID();
      if ( $last_id = get_post_meta($post_ID, '_edit_last', true) ) {
        $last_user = get_userdata($last_id);
        printf(__('Last edited by %1$s on %2$s at %3$s'), wp_specialchars( $last_user->display_name ), mysql2date(get_option('date_format'), $post->post_modified), mysql2date(get_option('time_format'), $post->post_modified));
      };
    ?>
  '';
  hideVersionSearch = "hideVersionAddendum";
  hideVersionText = builtins.replaceStrings ["$"] ["\\$"] ''
    /**
     * Hides the WP version from being easily scraped from the page meta tags
     */
    function wpbeginner_remove_version() {
      return "";
    }
    add_filter('the_generator', 'wpbeginner_remove_version');
  '';
  singleScriptSearch = "googleAnalyticsAddendum";
  singleScriptText= builtins.replaceStrings ["$"] ["\\$"] ''
    <script type="text/javascript">
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', '${gAnalytics}']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
    </script>
  '';
  singleSearch = "editedByAddendum";
  singleText= builtins.replaceStrings ["$"] ["\\$"] ''
    <?php
      $post_ID = get_the_ID();

      if ( $last_id = get_post_meta($post_ID, '_edit_last', true) ) {
        $last_user = get_userdata($last_id);
        printf(
          __('Last edited by %1$s on %2$s at %3$s'),
          wp_specialchars( $last_user->display_name ),
          mysql2date(get_option('date_format'),
          $post->post_modified),
          mysql2date(get_option('time_format'),
          $post->post_modified)
        );
      };
    ?>
  '';

  installPhase = ''
    mkdir -p $out
    cp -R * $out/
    
    sed -i 's%\(<!-- .entry-utility -->\)%\1@${loopSingleSearch}@%' $out/loop-single.php
    substituteInPlace $out/loop-single.php --subst-var-by ${loopSingleSearch} "${loopSingleText}"

    echo "" >> $out/functions.php
    echo "@${hideVersionSearch}@" >> $out/functions.php
    substituteInPlace $out/functions.php --subst-var-by ${hideVersionSearch} "${hideVersionText}"
    
    sed -i 's%\(<?php get_footer(); ?>\)%\1@${singleScriptSearch}@%' $out/single.php
    sed -i 's%\(<?php get_footer(); ?>\)%\1@${singleSearch}@%' $out/single.php
    substituteInPlace $out/single.php --subst-var-by ${singleScriptSearch} "${singleScriptText}"
    substituteInPlace $out/single.php --subst-var-by ${singleSearch} "${singleText}"
  '';
}
