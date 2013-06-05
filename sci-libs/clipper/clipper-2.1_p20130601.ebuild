# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/clipper/clipper-2.1_p100511-r1.ebuild,v 1.1 2013/05/28 18:15:50 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils flag-o-matic

MY_PV=${PV/_p/.}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Object-oriented libraries for crystallographic data and crystallographic computation"
HOMEPAGE="http://www.ysbl.york.ac.uk/~cowtan/clipper/clipper.html"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cctbx fortran static-libs"

RDEPEND="
	sci-libs/libccp4
	sci-libs/fftw:2.1
	sci-libs/mmdb"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

PATCHES=( "${FILESDIR}"/${P}-pkgconfig.patch )

src_configure() {
	# Recommended on ccp4bb/coot ML to fix crashes when calculating maps
	# on 64-bit systems
	append-flags -fno-strict-aliasing

	local myeconfargs=(
		--enable-ccp4
		--enable-cif
		--enable-cns
		--enable-contrib
		--enable-minimol
		--enable-mmdb
		--enable-mmdbold
		--enable-phs
		$(use_enable cctbx)
		$(use_enable fortran)
		)
	autotools-utils_src_configure
}

src_test() {
	emake -C "${AUTOTOOLS_BUILD_DIR}"/examples check
}
