# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit cmake python-single-r1 toolchain-funcs

DESCRIPTION="scalable C++ machine learning library"
HOMEPAGE="https://www.mlpack.org/"
SRC_URI="https://www.mlpack.org/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE+="arma-debug debug doc go julia matlab openmp profile R test"
REQUIRED_USE="${PYTHON_REQUIRED_USE} arma-debug? ( debug )"
RESTRICT="!test? ( test )"

CDEPEND="
	${PYTHON_DEPS}
	julia? ( || (
			dev-lang/julia
			dev-lang/julia-bin
		)
	)
	go? ( dev-lang/go )
	R? ( dev-lang/R )
"

RDEPEND="
	${CDEPEND}
	$(python_gen_cond_dep '
		dev-libs/boost[${PYTHON_USEDEP}]
		dev-libs/libxml2[${PYTHON_USEDEP}]
	')
	dev-python/pandas
	dev-python/cython
	dev-python/numpy
	dev-libs/stb
	>=sci-libs/armadillo-8.4.0[arpack,blas,lapack]
	sci-libs/ensmallen
"
DEPEND="${RDEPEND}"
BDEPEND="
	${CDEPEND}
	app-text/txt2man
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-libs/mathjax
	)
	test? ( $( python_gen_cond_dep '
		dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	elog "If you want to build matlab bindings then you"
	elog "need to make sure that matlab has been installed"
	elog "prior to building this package and it is available"
	elog "in the standard locations to be found by"
	elog "CMake, library finders, header includes and other"
	elog "trinkets that are used while compiling."
	elog "Matlab will not be entertained as a first class"
	elog "citizen until we have enough personnel"

	python-single-r1_pkg_setup
}

src_prepare() {
	sed -i \
		-e "s:share/doc/mlpack:share/doc/${PF}:" \
		-e 's/-O3//g' \
		CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDISABLE_DOWNLOADS=ON
		-DDOWNLOAD_ENSMALLEN=OFF
		-DDOWNLOAD_STB_IMAGE=OFF
		-DBUILD_WITH_COVERAGE=OFF
		-DBUILD_PYTHON_BINDINGS=ON
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_CLI_EXECUTABLES=ON
		-DTEST_VERBOSE=$(usex test)
		-DBUILD_TESTS=$(usex test)
		-DDEBUG=$(usex debug)
		-DPROFILE=$(usex profile)
		-DARMA_EXTRA_DEBUG=$(usex arma-debug)
		-DUSE_OPENMP=$(usex openmp)
		-DMATLAB_BINDINGS=$(usex matlab)
		-DBUILD_GO_SHLIB=$(usex go)
		-DBUILD_JULIA_BINDINGS=$(usex julia)
		-DBUILD_GO_BINDINGS=$(usex go)
		-DBUILD_R_BINDINGS=$(usex R)
		-DBUILD_MARKDOWN_BINDINGS=$(usex doc)
		-DMATHJAX=$(usex doc)
		${EXTRA_ECONF[@]}
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	python_optimize
}
