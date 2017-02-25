# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils eutils fortran-2 multilib toolchain-funcs

DESCRIPTION="Calculates maximally localized Wannier functions (MLWFs)"
HOMEPAGE="http://www.wannier.org/"
#SRC_URI="http://wannier.org/code/${P}.tar.gz"
SRC_URI="https://launchpad.net/${PN}/2.0/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc mpi perl test"

RDEPEND="
	virtual/blas
	virtual/lapack
	perl? ( dev-lang/perl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base
		dev-texlive/texlive-latexextra
		dev-tex/revtex
	)"

pkg_setup() {
	# fortran-2.eclass does not handle mpi wrappers
	if use mpi; then
		export FC="mpif90"
		export F77="mpif77"
		export CC="mpicc"
		export CXX="mpic++"
		export MPIFC="mpif90"
		export MPICC="mpicc"
	else
		tc-export FC F77 CC CXX
	fi

	# Preprocesor macross can make some lines really long
	append-fflags -ffree-line-length-none

	fortran-2_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/"$P"-runtest.patch
}

src_configure() {
	export LINALG_INCLUDES="$($(tc-getPKG_CONFIG) --cflags blas lapack)"
	export LINALG_LIBS="$($(tc-getPKG_CONFIG) --libs blas lapack)"
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	pushd "${BUILD_DIR}"/utility > /dev/null || die
	emake || die "emake in utility failed"
	popd > /dev/null || die
	if use doc; then
		VARTEXFONTS="${T}/fonts"
		pushd "${BUILD_DIR}"/doc/user_guide > /dev/null || die
		emake || die 'emake in doc/user_guide failed'
		cd "${BUILD_DIR}"/doc/tutorial
		emake || die 'emake in doc/tutorial failed'
		cd "${BUILD_DIR}"/utility/w90vdw/doc
		emake || die 'emake in utility/w90vdw/doc failed'
		cd "${BUILD_DIR}"/utility/w90pov/doc
		emake || die 'emake in utility/w90pov/doc failed'
		popd > /dev/null || die
	fi
}

src_test() {
	einfo "Compare the 'Standard' and 'Current' outputs of this test."
#	cd tests
#	emake test
	autotools-utils_src_compile check
	cat "${BUILD_DIR}"/tests/wantest.log
}

src_install() {
	autotools-utils_src_install
	dobin "${BUILD_DIR}"/utility/w90pov/src/w90pov.x
	dobin "${BUILD_DIR}"/utility/PL_assessment/w90_pl_assess.x
	use perl && dobin "$S"/utility/w90_kmesh.pl
	if use doc; then
		dodoc "${BUILD_DIR}"/doc/tutorial/tutorial.pdf
		dodoc "${BUILD_DIR}"/doc/user_guide/user_guide.pdf
		dodoc "${BUILD_DIR}"/utility/w90vdw/doc/w90vdw.pdf
		dodoc "${BUILD_DIR}"/utility/w90pov/doc/w90pov.pdf
	fi
}
