# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit check-reqs

DESCRIPTION="blast db"
HOMEPAGE="ftp://ftp.ncbi.nih.gov/blast/db/"
SRC_URI="${HOMEPAGE}/nr.00.tar.gz
	${HOMEPAGE}/nr.01.tar.gz
	${HOMEPAGE}/nr.02.tar.gz
	${HOMEPAGE}/nr.03.tar.gz"

LICENSE="public-domain"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks strip"

pkg_setup() {
	CHECKREQS_DISK_VAR="8500"
	CHECKREQS_DISK_USR="6700"
	check_reqs
}

src_install() {
	# avoid massive space and time consuming process
	dodir /usr/share/${PN}/
	mv * "${D}"/usr/share/${PN}/ || die
}
