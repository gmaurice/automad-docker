#!/bin/sh
if [ ! -f /app-pvc/config/accounts.php ];
then
	php automad/console createuser
	chown www-data:www-data config/accounts.php
	cp -a . /app-pvc
fi

