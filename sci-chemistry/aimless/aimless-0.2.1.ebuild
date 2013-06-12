# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Scale together multiple observations of reflections"
HOMEPAGE="http://www.mrc-lmb.cam.ac.uk/harry/pre/aimless.html"
SRC_URI="ftp://ftp.mrc-lmb.cam.ac.uk/pub/pre/${P}.tar.gz"

SLOT="0"
LICENSE="ccp4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND="
	sci-libs/clipper
	sci-libs/fftw:2.1
	sci-libs/libccp4[fortran]
	sci-libs/mmdb
	>=sci-libs/cctbx-2013"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}"

S="${WORKDIR}"

src_prepare() {
	sed \
		-e "s: ar :$(tc-getAR):g" \
		-i MinLib/Makefile || die
}

src_compile() {
	local myemakeargs=(
		CC=$(tc-getCC)
		CXX=$(tc-getCXX)
		CFLAGS="${CFLAGS}"
		CXXFLAGS="${CXXFLAGS}"
		LFLAGS="${LDFLAGS}"
		CLIB="${EPREFIX}/usr/$(get_libdir)"
		CCTBX_VERSION=2013
		ICCP4="$($(tc-getPKG_CONFIG) --cflags libccp4c libccp4f mmdb)"
		ICLPR="$($(tc-getPKG_CONFIG) --cflags clipper)"
		ITBX="$($(tc-getPKG_CONFIG) --cflags cctbx)"
		ITNT="-I${EPREFIX}/usr/include/tntbx/include/"
		LCCP4="$($(tc-getPKG_CONFIG) --libs libccp4c libccp4f mmdb)"
		LCLPR="$($(tc-getPKG_CONFIG) --libs clipper)"
		LTBX="$($(tc-getPKG_CONFIG) --libs cctbx)"
		SLIB=""
		)
	emake \
		-C MinLib \
		"${myemakeargs[@]}"
	emake \
		-f Makefile.make \
		"${myemakeargs[@]}"
}

src_install() {
	dobin ${PN}
}
