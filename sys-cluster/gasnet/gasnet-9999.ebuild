# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3

MY_P="${PN^^[gasn]}-${PV}"
DESCRIPTION="Networking middleware for partitioned global address space (PGAS) language"
HOMEPAGE="http://gasnet.lbl.gov/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="mpi threads"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

pkg_setup() {
	echo
	elog "GASNet has an overwhelming count of configuration options."
	elog "Don't forget the EXTRA_ECONF environment variable can let you"
	elog "specify configure options if you find them necessary."
	echo
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable threads pthreads)
		$(use_enable mpi)
	)
	econf ${myeconfargs[@]}
}
