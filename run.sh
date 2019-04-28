#!/bin/bash

if [[ -z "$PHP_MEMORY_LIMIT" ]];
then
	PHP_MEMORY_LIMIT=128M
fi

echo "Adjusting PHP memory limit to [$PHP_MEMORY_LIMIT]"
sed -i -e "s/^memory_limit =.*$/memory_limit = $PHP_MEMORY_LIMIT/g" /etc/php.ini

if [[ -z "$PHP_ERROR_REPORTING" ]];
then
	PHP_ERROR_REPORTING="E_ALL \\& ~E_DEPRECATED \\& ~E_STRICT"
fi

echo "Adjusting PHP error reporting to [$PHP_ERROR_REPORTING]"
sed -i -e "s/^error_reporting =.*$/error_reporting = $PHP_ERROR_REPORTING/g" /etc/php.ini

if [[ -z "$PHP_POST_MAX_SIZE" ]];
then
	PHP_POST_MAX_SIZE=8M
fi

echo "Adjusting PHP post max size to [$PHP_POST_MAX_SIZE]"
sed -i -e "s/^post_max_size = .*$/post_max_size = $PHP_POST_MAX_SIZE/g" /etc/php.ini

if [[ -z "$PHP_UPLOAD_MAX_FILESIZE" ]];
then
	PHP_UPLOAD_MAX_FILESIZE=8M
fi

echo "Adjusting PHP upload max file size to [$PHP_UPLOAD_MAX_FILESIZE]"
sed -i -e "s/^upload_max_filesize = .*$/upload_max_filesize = $PHP_UPLOAD_MAX_FILESIZE/g" /etc/php.ini

if [[ -z "$PHP_SESSION_SAVE_PATH" ]];
then
	PHP_SESSION_SAVE_PATH="/var/lib/php/session"
fi

echo "Adjusting PHP session save path to [$PHP_SESSION_SAVE_PATH]"
sed -i -e "s~^session\.save_path = .*$~session\.save_path = $PHP_SESSION_SAVE_PATH~g" /etc/php.ini
mkdir -p $PHP_SESSION_SAVE_PATH
chown nobody: /var/lib/php -R
chown nobody: $PHP_SESSION_SAVE_PATH -R

if [[ -z "$FPM_MAX_CHILDREN" ]];
then
	FPM_MAX_CHILDREN=5
fi

echo "Adjusting PHP-FPM max children to [$FPM_MAX_CHILDREN]"
sed -i -e "s/^pm.max_children = .*$/pm.max_children = $FPM_MAX_CHILDREN/g" /etc/php-fpm.d/www.conf

/usr/sbin/php-fpm -F -R
