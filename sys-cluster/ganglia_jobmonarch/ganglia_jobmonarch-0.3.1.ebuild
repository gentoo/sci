# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
WEBAPP_OPTIONAL="yes"
inherit eutils webapp depend.php python-r1

DESCRIPTION="Ganglia addons for Torque"
HOMEPAGE="https://oss.trac.surfsara.nl/jobmonarch/"
SRC_URI="http://ftp.surfsara.nl/pub/outgoing/jobmonarch/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="vhosts"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

WEBAPP_MANUAL_SLOT="yes"

GANGLIA="ganglia"
JOBMONARCH="ganglia_jobmonarch"

DEPEND="${PYTHON_DEPS}
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

	python_scriptinto /usr/sbin
	python_foreach_impl python_doscript \
		"${S}/jobmond/jobmond.py" \
		"${S}/jobarchived/jobarchived.py" \
		"${S}/jobarchived/pipe_jobarchived.py" \
		"${FILESDIR}/job_monarch_link.sh"

	newinitd "${FILESDIR}/jobmond.initd" jobmond
	newinitd "${FILESDIR}/jobarchived.initd" jobarchived

	cd "${S}/web/templates/job_monarch/" || die
	rm -r images || die

	cd "${S}" || die
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
