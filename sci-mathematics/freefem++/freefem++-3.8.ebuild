# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils flag-o-matic mpi versionator toolchain-funcs

MY_PV=$(replace_version_separator 2 '-')

DESCRIPTION="Solve PDEs using FEM on 2d and 3d domains"
HOMEPAGE="http://www.freefem.org/ff++/"
SRC_URI="http://www.freefem.org/ff%2B%2B/ftp/${PN}-${MY_PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples mpi opengl vim-syntax X"

RDEPEND="
	sci-libs/fftw
	virtual/cblas
	virtual/lapack
	sci-libs/umfpack
	sci-libs/arpack
	mpi? ( $(mpi_pkg_deplist) )
	opengl? (
		media-libs/freeglut
		virtual/opengl
		)
	vim-syntax? ( app-vim/freefem++-syntax )
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
		|| (
			(
				dev-texlive/texlive-latexrecommended
				dev-texlive/texlive-latexextra
			)
			app-text/ptex
			)
		virtual/latex-base
		media-gfx/imagemagick
		)"

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# acoptim.m4 forced -O2 removal
	epatch "${FILESDIR}"/${PN}-acoptim.patch
	# do not try to do a forced "manual" installation of
	# examples and documentation
	epatch "${FILESDIR}"/${PN}-no-doc-autobuild.patch
	# Honor FHS
	epatch "${FILESDIR}"/${PN}-path.patch

	eautoreconf
}

src_compile() {
	local myconf

	if use mpi; then
		myconf="${myconf} --with-mpi=$(mpi_pkg_cxx)"
	else
		myconf="--without-mpi"
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

	emake || die "emake failed"

	if use doc; then
		emake documentation || die "emake documentation failed"
	fi
}

src_test() {
	if use mpi; then
		# This may depend on the used MPI implementation. It is needed
		# with mpich2, but should not be needed with lam-mpi or mpich
		# (if the system is configured correctly).
		ewarn "Please check that your MPI root ring is on before running"
		ewarn "the test phase. Failing to start it before that phase may"
		ewarn "result in a failing emerge."
		epause
	fi
	emake -j1 check || die "check test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS INNOVATION HISTORY* README

	insinto /usr/share/doc/${PF}
	if use doc; then
		doins DOC/freefem++doc.pdf || die
	fi

	if use examples; then
		einfo "Installing examples..."

		# Remove compiled examples:
		emake clean || die "emake clean failed"

		einfo "Some of the installed examples assumes that the user has write"
		einfo "permissions in the working directory and other will look for"
		einfo "data files in the working directory. For this reason in order to"
		einfo "run the examples it's better to temporary copy them somewhere"
		einfo "in the user folder. For example to run the tutorial examples"
		einfo "it's better to copy the entire examples++-tutorial folder into"
		einfo "the user directory."

		rm -f examples*/Makefile*
		doins -r examples*
	fi
}
