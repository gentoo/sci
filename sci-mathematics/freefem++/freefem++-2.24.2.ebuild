# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools versionator flag-o-matic

MY_PV=$(replace_version_separator 2 '-')

DESCRIPTION="Solve PDEs using FEM on 2d domains"
HOMEPAGE="http://www.freefem.org/ff++/"
SRC_URI="http://www.freefem.org/ff%2B%2B/ftp/${PN}-${MY_PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples fltk mpi vim-syntax X"

RDEPEND="sci-libs/fftw
	virtual/cblas
	virtual/lapack
	sci-libs/umfpack
	>=sci-libs/arpack-96-r2
	vim-syntax? ( app-vim/freefem++-syntax )
	X? (
		x11-libs/libXpm
		fltk? ( x11-libs/fltk )
		)
	mpi? ( virtual/mpi )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( virtual/latex-base media-gfx/imagemagick )"

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# acoptim.m4 forced -O2 removal
	epatch "${FILESDIR}"/${PN}-acoptim.patch
	eautoreconf
}

src_compile() {
	local myconf

	# Tested using mpich2, upstream built freefem++ with mpich and lam-mpi.
	# So it should work, at least with this three MPI implementations.
	if use mpi; then
		if has_version sys-cluster/mpich2 ; then
			myconf="${myconf} --with-mpi=mpicxx"
		else
			myconf="${myconf} --with-mpi=mpiCC"
		fi
	else
		myconf="--without-mpi"
	fi

	use fltk && append-cppflags $(fltk-config --cflags)

	econf \
		--disable-download \
		--disable-optim \
		--enable-generic \
		--with-blas="$(pkg-config --libs blas)" \
		--with-lapack="$(pkg-config --libs lapack)" \
		$(use_with fltk) \
		$(use_with X x) \
		${myconf} \
		|| die "econf failed"

	emake || die "emake failed"

	if use doc; then
		emake documentation || die "emake documentation failed"
	fi
}

src_test() {
	# This may depend on the used MPI implementation. It is needed
	# with mpich2, but should not be needed with lam-mpi or mpich
	# (if the system is configured correctly).
	ewarn "Please check that your MPI root ring is on before running"
	ewarn "the test phase. Failing to start it before that phase may"
	ewarn "result in a failing emerge."
	epause
	emake -j1 check || die "check test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use fltk; then
		einfo "\"FreeFem++-ide\" is not intended for user use."
		einfo "Use the \"FreeFem++-cs\" command to access the IDE."
		einfo
	fi

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
		doins regtests.sh
		rm -f examples*/Makefile*
		doins -r examples*
	fi
}
