<?php
# Database Configuration
define( 'DB_NAME', 'wp_cmetree' );
define( 'DB_USER', 'cmetree' );
define( 'DB_PASSWORD', 'mqV4UipEW7jmHckKcNNe' );
define( 'DB_HOST', '127.0.0.1' );
define( 'DB_HOST_SLAVE', '127.0.0.1' );
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', 'utf8_unicode_ci');
$table_prefix = 'wp_';

# Security Salts, Keys, Etc
define('AUTH_KEY',         '& KlQa,qzhLU0GSAwEx0`1gNF-%6T-1YsR5=C++2y*7Yy~<znTc7]ytKZMTh[>UC');
define('SECURE_AUTH_KEY',  '?8e6%GqFhd_0m{9Tc|1VE! N.0O%`R8!ITS|!+7ytdZ&04].-d&[F 1Q}?+g|6W4');
define('LOGGED_IN_KEY',    'F+UcLfK$jzcTfaC*`e|Gk@`TkOTiewE4NXG)oDKW?:Fk$K-(R7hC(T@&w+f&M c@');
define('NONCE_KEY',        'o7q&-iw|Z3:/CLXHsTbun289* }</Y1{Bj0WQ=`&r+2Yzj<=D?>+,uQYZb;{VX2-');
define('AUTH_SALT',        'dU@a+um!mNW+nE.(.| *NOFA5P?(`b-7AQ`CD{ZIO8n-_f=iyq92d;TAA~%1+N8F');
define('SECURE_AUTH_SALT', '&REfZhV9OB[ 0_|*%Lxm#-|iMm!460ka.M?5rrT-L/{6fjJ&XF%2RaG:)]Pa&)fg');
define('LOGGED_IN_SALT',   'V:+DFg*SVqNzO0-P*8vNNhR#  ,&vHFrL|(CSb&#Dmb+EQ[b:K4citS08)Jc:LFB');
define('NONCE_SALT',       'WaoaT=(.c6j XHxYKEADNJqwr{I?bpuUk$5e#o[FM3&pF8_|;=iGS:(_&VCvfgbK');


# Localized Language Stuff

define( 'WP_CACHE', TRUE );

define( 'WP_AUTO_UPDATE_CORE', false );

define( 'PWP_NAME', 'cmetree' );

define( 'FS_METHOD', 'direct' );

define( 'FS_CHMOD_DIR', 0775 );

define( 'FS_CHMOD_FILE', 0664 );

define( 'PWP_ROOT_DIR', '/nas/wp' );

define( 'WPE_APIKEY', '94e7eaabb19c5e485f7bddbf6152406390263f2d' );

define( 'WPE_CLUSTER_ID', '120361' );

define( 'WPE_CLUSTER_TYPE', 'pod' );

define( 'WPE_ISP', true );

define( 'WPE_BPOD', false );

define( 'WPE_RO_FILESYSTEM', false );

define( 'WPE_LARGEFS_BUCKET', 'largefs.wpengine' );

define( 'WPE_SFTP_PORT', 2222 );

define( 'WPE_LBMASTER_IP', '' );

define( 'WPE_CDN_DISABLE_ALLOWED', false );

define( 'DISALLOW_FILE_MODS', FALSE );

define( 'DISALLOW_FILE_EDIT', FALSE );

define( 'DISABLE_WP_CRON', false );

define( 'WPE_FORCE_SSL_LOGIN', false );

define( 'FORCE_SSL_LOGIN', false );

/*SSLSTART*/ if ( isset($_SERVER['HTTP_X_WPE_SSL']) && $_SERVER['HTTP_X_WPE_SSL'] ) $_SERVER['HTTPS'] = 'on'; /*SSLEND*/

define( 'WPE_EXTERNAL_URL', false );

define( 'WP_POST_REVISIONS', FALSE );

define( 'WPE_WHITELABEL', 'wpengine' );

define( 'WP_TURN_OFF_ADMIN_BAR', false );

define( 'WPE_BETA_TESTER', false );

umask(0002);

$wpe_cdn_uris=array ( );

$wpe_no_cdn_uris=array ( );

$wpe_content_regexs=array ( );

$wpe_all_domains=array ( 0 => 'cmetree.wpengine.com', 1 => 'tree.mediaengagement.org', );

$wpe_varnish_servers=array ( 0 => 'pod-120361', );

$wpe_special_ips=array ( 0 => '35.196.210.212', );

$wpe_ec_servers=array ( );

$wpe_netdna_domains=array ( );

$wpe_netdna_domains_secure=array ( );

$wpe_netdna_push_domains=array ( );

$wpe_domain_mappings=array ( );

$memcached_servers=array ( );
define('WPLANG','');

# WP Engine ID


# WP Engine Settings






# That's It. Pencils down
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');














