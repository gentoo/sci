# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4

DESCRIPTION="Programm for visualisation and processing of experimental and simulated NMR spectra"
HOMEPAGE="http://sourceforge.net/projects/gsim"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"

RDEPEND="x11-libs/qt-svg:4
	dev-cpp/muParser
	sci-libs/libcmatrix
	virtual/blas
	media-libs/freetype
	opengl? ( x11-libs/qt-opengl:4 )"
DEPEND="${RDEPEND}"

src_prepare() {
	use opengl && \
		epatch "${FILESDIR}"/${PV}-pro-opengl.patch || \
		epatch "${FILESDIR}"/${PV}-pro-normal.patch
}

src_compile() {
	eqmake4 ${PN}.pro

	emake || die "compile error"
}

src_install() {
	dobin ${PN} || die "no ${PN}"
	insinto /usr/share/${PN}
	doins images/*
	dodoc README_GSIM.{pdf,odt} || die "nodocs"
}
