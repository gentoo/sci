# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=y

inherit autotools-utils flag-o-matic  fortran-2

_AP=001

DESCRIPTION="The USF program suite"
HOMEPAGE="http://xray.bmc.uu.se/usf/"
SRC_URI="
	http://xray.bmc.uu.se/markh/usf/usf_distribution_kit.tar.gz -> ${P}.tar.gz
	http://dev.gentoo.org/~jlec/distfiles/${PN}-autotools-${_AP}.tar.xz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS=""
IUSE="static-libs"

RDEPEND="
	sci-libs/libccp4
	sci-libs/mmdb:0"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/usf_export

src_prepare() {
	append-fflags -ffixed-line-length-132 -DLINUX -cpp
	autotools-utils_src_prepare
}
