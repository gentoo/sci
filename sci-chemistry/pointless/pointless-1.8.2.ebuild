# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/pointless/pointless-1.6.14.ebuild,v 1.3 2012/10/19 15:19:34 jlec Exp $

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Scores crystallographic Laue and space groups"
HOMEPAGE="ftp://ftp.mrc-lmb.cam.ac.uk/pub/pre/pointless.html"
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

src_compile() {
	emake  \
		-f Makefile.make \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LFLAGS="${LDFLAGS}" \
		CLIB="${EPREFIX}/usr/$(get_libdir)" \
		CCTBX_VERSION=2013 \
		ICCP4="$(pkg-config --cflags libccp4c libccp4f mmdb)" \
		ICLPR="$(pkg-config --cflags clipper)" \
		ITBX="$(pkg-config --cflags cctbx)" \
		LCCP4="$(pkg-config --libs libccp4c libccp4f mmdb)"\
		LCLPR="$(pkg-config --libs clipper)" \
		LTBX="$(pkg-config --libs cctbx)" \
		SLIB=""
}

src_install() {
	dobin pointless othercell
}
