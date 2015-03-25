# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

WEBAPP_OPTIONAL="yes"
inherit eutils webapp depend.php

DESCRIPTION="Ganglia addons for Torque"
HOMEPAGE="https://subtrac.sara.nl/oss/jobmonarch/"
SRC_URI="ftp://ftp.sara.nl/pub/outgoing/jobmonarch/latest/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="vhosts"
WEBAPP_MANUAL_SLOT="yes"

GANGLIA="ganglia"
JOBMONARCH="ganglia_jobmonarch"

DEPEND="
	sys-cluster/ganglia
	dev-lang/php[gd,xml,ctype]
	media-libs/gd
	sys-cluster/pbs-python
	dev-python/pypgsql
	${WEBAPP_DEPEND}"

pkg_setup() {
	webapp_pkg_setup
}

src_compile() {
	einfo "Nothing to do"
}

src_install() {
	insinto /etc
	doins "${S}/jobmond/jobmond.conf"
	doins "${S}/jobarchived/jobarchived.conf"

	insinto /usr/share/jobmonarch/
	doins "${S}/jobarchived/job_dbase.sql"

	dodir /var/lib/jobarchive

	insopts -m0755
	insinto /sbin
	doins "${S}/jobmond/jobmond.py"
	doins "${S}/jobarchived/jobarchived.py"
	doins "${S}/jobarchived/pipe_jobarchived.py"
	doins "${FILESDIR}/job_monarch_link.sh"

	newinitd "${FILESDIR}/jobmond.initd" jobmond
	newinitd "${FILESDIR}/jobarchived.initd" jobarchived

	cd "${S}/web/templates/job_monarch/"
	rm images/*
	rmdir images

	cd "${S}"
	webapp_src_preinst
	insinto "${MY_HTDOCSDIR}"
	doins -r web/*

	webapp_configfile "${MY_HTDOCSDIR}"/addons/job_monarch/conf.php
	webapp_src_install

	ewarn
	ewarn "You must Execute: job_monarch_link.sh install ${GANGLIA} ${JOBMONARCH} to have the JobMonArch installed under ganglia"
	ewarn
	ewarn "You must Execute: job_monarch_link.sh uninstall ${GANGLIA} to remove link from ganglia directories"
	ewarn
}
