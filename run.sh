#!/bin/bash

if [[ -z "$PHP_MEMORY_LIMIT" ]];
then
	PHP_MEMORY_LIMIT=128M
fi

echo "Adjusting PHP memory limit to [$PHP_MEMORY_LIMIT]"
sed -i -r -e "s/^;?memory_limit =.*$/memory_limit = $PHP_MEMORY_LIMIT/g" /etc/php.ini

if [[ -z "$PHP_ERROR_REPORTING" ]];
then
	PHP_ERROR_REPORTING="E_ALL \\& ~E_DEPRECATED \\& ~E_STRICT"
fi

echo "Adjusting PHP error reporting to [$PHP_ERROR_REPORTING]"
sed -i -r -e "s/^;?error_reporting =.*$/error_reporting = $PHP_ERROR_REPORTING/g" /etc/php.ini

if [[ -z "$PHP_POST_MAX_SIZE" ]];
then
	PHP_POST_MAX_SIZE=8M
fi

echo "Adjusting PHP post max size to [$PHP_POST_MAX_SIZE]"
sed -i -r -e "s/^;?post_max_size = .*$/post_max_size = $PHP_POST_MAX_SIZE/g" /etc/php.ini

if [[ -z "$PHP_UPLOAD_MAX_FILESIZE" ]];
then
	PHP_UPLOAD_MAX_FILESIZE=8M
fi

echo "Adjusting PHP upload max file size to [$PHP_UPLOAD_MAX_FILESIZE]"
sed -i -r -e "s/^;?upload_max_filesize = .*$/upload_max_filesize = $PHP_UPLOAD_MAX_FILESIZE/g" /etc/php.ini

if [[ -z "$PHP_SESSION_SAVE_PATH" ]];
then
	PHP_SESSION_SAVE_PATH="/var/lib/php/session"
fi

echo "Adjusting PHP session save path to [$PHP_SESSION_SAVE_PATH]"
sed -i -r -e "s~^;?session\.save_path = .*$~session\.save_path = $PHP_SESSION_SAVE_PATH~g" /etc/php.ini
mkdir -p $PHP_SESSION_SAVE_PATH
chown nobody: /var/lib/php -R
chown nobody: $PHP_SESSION_SAVE_PATH -R

echo "Configure Cache"
sed -i -r -e "s~^;?realpath_cache_size = .*$~realpath_cache_size = 4M~g" /etc/php.ini
sed -i -r -e "s~^;?realpath_cache_ttl = .*$~realpath_cache_ttl = 120~g" /etc/php.ini
sed -i -r -e "s~^;?expose_php = .*$~expose_php = Off~g" /etc/php.ini
sed -i -r -e "s~^;?opcache\.validate_timestamps=.*$~opcache\.validate_timestamps=1~g" /etc/php.d/10-opcache.ini
sed -i -r -e "s~^;?opcache\.revalidate_freq=.*$~opcache\.revalidate_freq=180~g" /etc/php.d/10-opcache.ini
# Removed due to (https://tideways.com/profiler/blog/fine-tune-your-opcache-configuration-to-avoid-caching-suprises)
#sed -i -r -e "s~^;?opcache\.fast_shutdown=.*$~opcache\.fast_shutdown=1~g" /etc/php.d/10-opcache.ini
sed -i -r -e "s~^;?opcache\.file_cache=.*$~opcache\.file_cache=/var/lib/php/opcache~g" /etc/php.d/10-opcache.ini
sed -i -r -e "s~^;?opcache\.file_cache_only=.*$~opcache\.file_cache_only=1~g" /etc/php.d/10-opcache.ini
sed -i -r -e "s~^;?opcache\.file_cache_consistency_checks=.*$~opcache\.file_cache_consistency_checks=1~g" /etc/php.d/10-opcache.ini


if [[ -z "$FPM_MAX_CHILDREN" ]];
then
	FPM_MAX_CHILDREN=5
fi

echo "Adjusting PHP-FPM max children to [$FPM_MAX_CHILDREN]"
sed -i -r -e "s/^;?pm.max_children = .*$/pm.max_children = $FPM_MAX_CHILDREN/g" /etc/php-fpm.d/www.conf

/usr/sbin/php-fpm -F -R
