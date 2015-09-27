# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 python-single-r1

MY_PN="clBLAS"

DESCRIPTION="A software library containing BLAS routines for OpenCL"
HOMEPAGE="https://github.com/clMathLibraries/clBLAS"
EGIT_REPO_URI="https://github.com/clMathLibraries/${MY_PN}.git git://github.com/clMathLibraries/${MY_PN}.git"
S="${WORKDIR}/${P}/src"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+client examples +ktest performance test"

RDEPEND="
	>=sys-devel/gcc-4.6:*
	virtual/opencl
	|| ( >=dev-util/amdapp-2.9 dev-util/intel-ocl-sdk )
	dev-libs/boost
	performance? ( ${PYTHON_DEPS} )
	"
DEPEND="${RDEPEND}"
#	test? (
#		>=dev-cpp/gtest-1.6.0
#		>=sci-libs/acml-6.1.0.3
#	)"

# The tests only get compiled to an executable named Test, which is not recogniozed by cmake.
# Therefore src_test() won't execute any test.
RESTRICT="test"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(gcc-major-version) -lt 4 ]] || ( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ]] ) ; then
			die "Compilation with gcc older than 4.6 is not supported."
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build client CLIENT)
		$(cmake-utils_use_build examples SAMPLE)
		$(cmake-utils_use_build ktest KTEST)
		$(cmake-utils_use_build performance PERFORMANCE)
		$(cmake-utils_use_build test TEST)
	)
	cmake-utils_src_configure
}
