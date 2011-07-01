#!/bin/sh

install() {
	cd /var/www/localhost/htdocs/$1
	mkdir addons; mkdir addons/job_monarch; cd addons/job_monarch
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/cal.gif
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/conf.php
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/document_archive.jpg
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/footer.php
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/graph.php
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/header.php
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/host_view.php
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/image.php
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/index.php
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/jobmonarch.gif
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/libtoga.js
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/libtoga.php
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/logo_ned.gif
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/next.gif
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/overview.php
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/prev.gif
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/redcross.jpg
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/search.php
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/styles.css
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/ts_picker.js
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/ts_validatetime.js
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/version.php

	mkdir clusterconf; cd clusterconf
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/clusterconf/example.php
	cd ..

	mkdir templates; cd templates
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/templates/footer.tpl
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/templates/header.tpl
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/templates/host_view.tpl
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/templates/index.tpl
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/templates/overview.tpl
	ln /var/www/localhost/htdocs/$2/addons/job_monarch/templates/search.tpl
	ln -s ../../../templates/default/images

	cd /var/www/localhost/htdocs/$1
	mkdir templates/job_monarch; cd templates/job_monarch
	ln /var/www/localhost/htdocs/$2/templates/job_monarch/cluster_extra.tpl
	ln /var/www/localhost/htdocs/$2/templates/job_monarch/host_extra.tpl
	ln -s ../default/images
}

uninstall() {
	rm -Rf /var/www/localhost/htdocs/$1/addons/job_monarch/* && rmdir /var/www/localhost/htdocs/$1/addons/job_monarch && rmdir /var/www/localhost/htdocs/$1/addons
	rm -Rf /var/www/localhost/htdocs/$1/templates/job_monarch/* && rmdir /var/www/localhost/htdocs/$1/templates/job_monarch
}

case "$1" in
	install)
		install $2 $3
	;;
	uninstall)
		uninstall $2
	;;
	*)
		echo -e "\033[34;1mUsage: job_monarch_link.sh [ install <ganglia_dir> <jobmonarch_dir> | uninstall <ganglia_dir> ]\033[0m"
	;;
esac
