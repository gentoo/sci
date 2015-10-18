# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

MY_P="${PN^^[gasn]}-${PV}"
DESCRIPTION="networking middleware layer to implementing partitioned global address space (PGAS) language"
HOMEPAGE="http://gasnet.lbl.gov/"
SRC_URI="http://gasnet.lbl.gov/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mpi threads"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	find . \( -name Makefile.am -or -name "*.mak" \) -exec sed -i '/^docdir/s/^/#/' {} + || die
	AUTOTOOLS_AUTORECONF=yes
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable threads pthreads)
		$(use_enable mpi)
	)
	autotools-utils_src_configure
}
