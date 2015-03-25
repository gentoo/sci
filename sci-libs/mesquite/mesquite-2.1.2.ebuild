# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Mesh Quality Improvement Toolkit"
HOMEPAGE="http://www.cs.sandia.gov/optimization/knupp/Mesquite.html"
SRC_URI="http://software.sandia.gov/~jakraft/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	econf \
	--enable-shared             \
	--disable-imesh             \
	--disable-igeom             \
	--disable-irel              \
	--without-cppunit           \
	--enable-trap-fpe           \
	--disable-function-timers

	## make sure the Mesquite_all_headers.hpp is generated
	# with new configure flags!
	emake mostlyclean-generic || die "emake mostlyclean-generic failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed!"
}
