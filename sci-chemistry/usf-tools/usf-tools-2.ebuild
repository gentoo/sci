# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools fortran-2

DESCRIPTION="The USF program suite"
HOMEPAGE="http://xray.bmc.uu.se/markh/usf"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="as-is"
IUSE=""

RDEPEND="
	sci-libs/ccp4-libs
	sci-libs/mmdb"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/

src_prepare() {
	eautoreconf
}
