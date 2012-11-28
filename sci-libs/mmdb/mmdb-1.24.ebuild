# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/mmdb/mmdb-1.24.ebuild,v 1.3 2012/05/21 19:14:15 ranger Exp $

EAPI=4

inherit autotools-utils pkgconfig

DESCRIPTION="The Coordinate Library, designed to assist CCP4 developers in working with coordinate files"
HOMEPAGE="http://launchpad.net/mmdb/"
SRC_URI="
	http://www.ysbl.york.ac.uk/~emsley/software/${P}.tar.gz
	http://launchpad.net/mmdb/1.23/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

DEPEND="!<sci-libs/ccp4-libs-6.1.3"
RDEPEND=""

#PATCHES=(
#	"${FILESDIR}"/1.23.2.2-pkg-config.patch
#	)

src_install() {
	autotools-utils_src_install

	# create missing mmdb.pc
	create_pkgconfig ${PN} \
		-I "${EPREFIX}/usr/include/mmdb" \
		-l "-L${EPREFIX}/usr/$(get_libdir) -lmmdb" \
		-c "-I${EPREFIX}/usr/include/mmdb"
}
