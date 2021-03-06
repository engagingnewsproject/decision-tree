<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInit2ab4f31e916b7f2a91ceb237a10488e6
{
    public static $files = array (
        '253c157292f75eb38082b5acb06f3f01' => __DIR__ . '/..' . '/nikic/fast-route/src/functions.php',
        '72b6e3bb514d7b655cf60d779b43a55c' => __DIR__ . '/../..' . '/src/Utility.php',
        '303ca7f391c1c38f523e86b12dda9249' => __DIR__ . '/../..' . '/tree-config.php',
        'c88700f927f8d5638bed72bf95409ede' => __DIR__ . '/../..' . '/tree-db.php',
    );

    public static $prefixLengthsPsr4 = array (
        'S' => 
        array (
            'Slim\\Views\\' => 11,
            'Slim\\' => 5,
        ),
        'P' => 
        array (
            'Psr\\Http\\Message\\' => 17,
            'Psr\\Container\\' => 14,
        ),
        'L' => 
        array (
            'LightnCandy\\' => 12,
        ),
        'I' => 
        array (
            'Interop\\Container\\' => 18,
        ),
        'F' => 
        array (
            'FastRoute\\' => 10,
        ),
        'C' => 
        array (
            'Cme\\' => 4,
        ),
    );

    public static $prefixDirsPsr4 = array (
        'Slim\\Views\\' => 
        array (
            0 => __DIR__ . '/..' . '/slim/php-view/src',
        ),
        'Slim\\' => 
        array (
            0 => __DIR__ . '/..' . '/slim/slim/Slim',
        ),
        'Psr\\Http\\Message\\' => 
        array (
            0 => __DIR__ . '/..' . '/psr/http-message/src',
        ),
        'Psr\\Container\\' => 
        array (
            0 => __DIR__ . '/..' . '/psr/container/src',
        ),
        'LightnCandy\\' => 
        array (
            0 => __DIR__ . '/..' . '/zordius/lightncandy/src',
        ),
        'Interop\\Container\\' => 
        array (
            0 => __DIR__ . '/..' . '/container-interop/container-interop/src/Interop/Container',
        ),
        'FastRoute\\' => 
        array (
            0 => __DIR__ . '/..' . '/nikic/fast-route/src',
        ),
        'Cme\\' => 
        array (
            0 => __DIR__ . '/../..' . '/src',
        ),
    );

    public static $prefixesPsr0 = array (
        'P' => 
        array (
            'Pimple' => 
            array (
                0 => __DIR__ . '/..' . '/pimple/pimple/src',
            ),
        ),
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->prefixLengthsPsr4 = ComposerStaticInit2ab4f31e916b7f2a91ceb237a10488e6::$prefixLengthsPsr4;
            $loader->prefixDirsPsr4 = ComposerStaticInit2ab4f31e916b7f2a91ceb237a10488e6::$prefixDirsPsr4;
            $loader->prefixesPsr0 = ComposerStaticInit2ab4f31e916b7f2a91ceb237a10488e6::$prefixesPsr0;

        }, null, ClassLoader::class);
    }
}
