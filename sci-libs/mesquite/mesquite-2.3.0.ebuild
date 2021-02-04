# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Mesh Quality Improvement Toolkit"
HOMEPAGE="https://trilinos.github.io/mesquite.html"
SRC_URI="https://software.sandia.gov/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_configure() {
	econf \
	--enable-shared             \
	--disable-imesh             \
	--disable-igeom             \
	--disable-irel              \
	--without-cppunit           \
	--enable-trap-fpe           \
	--disable-function-timers
}

src_compile() {
	## make sure the Mesquite_all_headers.hpp is generated
	# with new configure flags!
	emake mostlyclean-generic
}
