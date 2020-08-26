# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 autotools eutils flag-o-matic mpi versionator toolchain-funcs

DESCRIPTION="Solve PDEs using FEM on 2d and 3d domains"
HOMEPAGE="http://www.freefem.org/ff++/"
EGIT_REPO_URI="https://github.com/FreeFem/FreeFem-sources"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples mpi opengl X"

RDEPEND="
	sci-libs/fftw:3.0
	virtual/cblas
	virtual/lapack
	sci-libs/umfpack
	sci-libs/arpack
	sci-libs/hdf5[cxx,mpi?]
	mpi? ( $(mpi_pkg_deplist) )
	opengl? (
		media-libs/freeglut
		virtual/opengl
		)
	X? (
		media-fonts/font-misc-misc
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXpm
		x11-libs/libXxf86vm
		)"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		dev-texlive/texlive-latexrecommended
		dev-texlive/texlive-latexextra
		virtual/latex-base
		media-gfx/imagemagick
		)"

src_prepare() {
	epatch "${FILESDIR}"/${P}-glut.patch
	eautoreconf
}

src_configure() {
	local myconf

	if use mpi; then
		myconf="${myconf} --with-mpi=$(mpi_pkg_cxx)"
	else
		myconf="--without-mpi"
	fi

	if use X; then
		myconf="${myconf} --with-glut"
	fi

	econf \
		--disable-download \
		--disable-optim \
		--enable-generic \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)" \
		$(use_enable opengl) \
		$(use_with X x) \
		${myconf}
}
