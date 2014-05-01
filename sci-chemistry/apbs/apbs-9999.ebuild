# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/apbs/apbs-1.3-r3.ebuild,v 1.5 2013/05/02 15:16:35 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils flag-o-matic git-r3 multilib python-single-r1 toolchain-funcs

DESCRIPTION="Evaluation of electrostatic properties of nanoscale biomolecular systems"
HOMEPAGE="http://www.poissonboltzmann.org/apbs/"
SRC_URI=""
EGIT_REPO_URI="git://git.code.sf.net/p/apbs/code"

SLOT="0"
LICENSE="BSD"
KEYWORDS=""
IUSE="debug examples +fetk mpi +openmp +tools"

RDEPEND="${PYTHON_DEPS}
	dev-libs/maloc[mpi=]
	virtual/blas
	sys-libs/readline
	fetk? (
		sci-libs/fetk
		sci-libs/amd
		sci-libs/umfpack
		sci-libs/superlu )
	mpi? ( virtual/mpi )"
DEPEND="${DEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-manip.patch
	"${FILESDIR}"/${P}-prll.patch
)

DOCS=(
	doc/{APBS-1.4-README.txt,ChangeLog,README}
)

src_prepare() {
	local _examples

	use examples || examples=$(ls examples/*)

	rm -rf \
		contrib/maloc* include/Eigen/* \
		doc/{license,release_procedure.txt,programmer,CMakeLists.txt} \
		${examples} \
		|| die

	append-cppflags $($(tc-getPKG_CONFIG) --cflags eigen3)

	sed \
		-e "s:-lblas:$($(tc-getPKG_CONFIG) --libs blas):g" \
		-e 's:-lg2c::g' \
		-i CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSYS_LIBPATHS="${EPREFIX}"/usr/$(get_libdir)
		-DLIBRARY_INSTALL_PATH=$(get_libdir)
		-DFETK_PATH="${EPREFIX}"/usr/
		-DBUILD_SHARED_LIBS=ON
		-DENABLE_PYTHON=ON
		$(cmake-utils_use_build tools)
		$(cmake-utils_use_enable debug)
# Not acitve in the code yet
#		$(cmake-utils_use_enable fast)
		$(cmake-utils_use_enable fetk)
		$(cmake-utils_use_enable mpi)
		$(cmake-utils_use_enable openmp)
	)
	cmake-utils_src_configure
}

src_test() {
	cd tests || die
	"${PYTHON}" apbs_tester.py -l log || die
	grep -q 'FAILED' log && die "Tests failed"
}

src_install() {
	cmake-utils_src_install
	python_optimize "${ED}"
}
