# php-fpm

## About

![](https://img.shields.io/github/license/alleotech/docker-php-fpm)

PHP-FPM Docker Image by [AlleoTech Ltd](https://alleo.tech).

## Usage

```
docker run -d --name php-fpm alleotech/php-fpm
```

## Configuration via ENV

It is possible to adjust few configuration parameters during
the start of the image via ENV (-e var=value). Keep in mind 
that settings are applied with *sed* regexp and thus should be 
escaped accordingly (see PHP_ERROR_REPORTING as an example).

* PHP_MEMORY_LIMIT: `php.ini` memory_limit param (default: `128M`)
* PHP_ERROR_REPORTING: `php.ini` error_reporing (default: `E_ALL \\& ~E_DEPRECATED \\& ~E_STRICT`)
* PHP_POST_MAX_SIZE: `php.ini` php_post_max_size (default: `8M`)
* PHP_UPLOAD_MAX_FILESIZE: `php.ini` upload_max_filesize (default: `8M`)
* PHP_MAX_EXECUTION_TIME: `php.ini` max_execution_time (default: `30`)
* PHP_MAX_INPUT_VARS: `php.ini` max_input_vars (default: `1000`)
* PHP_SESSION_SAVE_PATH: `php.ini` session.save_path (default: `/var/lib/php/session`)
* FPM_MAX_CHILDREN: `php-fpm.d/www.conf` pm.max_children (default: `5`)

## Notes

* user = nobody
* pm = static
* port = 9000
* listen and allowed clients = 0.0.0.0
