<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInitd831e4b63924037e6f38c4eae6a9f54c
{
    public static $classMap = array (
        'Composer\\InstalledVersions' => __DIR__ . '/..' . '/composer/InstalledVersions.php',
        'Facebook\\AutoloadMap\\ComposerPlugin' => __DIR__ . '/..' . '/hhvm/hhvm-autoload/ComposerPlugin.php',
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->classMap = ComposerStaticInitd831e4b63924037e6f38c4eae6a9f54c::$classMap;

        }, null, ClassLoader::class);
    }
}
