# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fortran-2

DESCRIPTION="The lowest-level Growler library"
HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"
SRC_URI="${HOMEPAGE}/downloads/growler-link-${PV}.tar.gz"

SLOT="0"
LICENSE="NOSA"
KEYWORDS="~amd64 ~x86"
IUSE="doc fortran static-libs tcpd"

RDEPEND="
	dev-libs/boost
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PV}-gcc4.patch
	"${FILESDIR}"/${PV}-gcc4.7.patch
	)

src_configure() {
	local myeconfargs=(
		$(use_enable doc)
		$(use_enable tcpd)
		$(use_enable static-libs static)
		)
	econf ${myeconfargs[@]}
}
