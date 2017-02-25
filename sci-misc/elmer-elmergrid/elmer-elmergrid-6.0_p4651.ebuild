# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils multilib

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Finite element programs, libraries, and visualization tools - elmergrid"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
SRC_URI="http://elmerfem.svn.sourceforge.net/viewvc/${ELMER_ROOT}/release/${PV%_p*}/${MY_PN}/?view=tar&pathrev=4651 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	sci-libs/matc
	sci-libs/metis"
DEPEND="${RDEPEND}"

S="${WORKDIR}/elmergrid"

src_configure() {
	local myeconfargs=(
		$(use_with debug)
		--with-metis-libs="${EPREFIX}"/usr/$(get_libdir)
		--with-metis-include="${EPREFIX}"/usr/include/metis
	)
	autotools-utils_src_configure
}
