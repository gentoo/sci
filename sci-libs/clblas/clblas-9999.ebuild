# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 python-single-r1

MY_PN="clBLAS"

DESCRIPTION="A software library containing BLAS routines for OpenCL"
HOMEPAGE="https://github.com/clMathLibraries/clBLAS"
EGIT_REPO_URI="https://github.com/clMathLibraries/${MY_PN}.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+client examples +ktest performance test"

REQUIRED_USE="performance? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/boost
	virtual/opencl
	|| ( >=dev-util/amdapp-2.9 dev-util/intel-ocl-sdk )
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

S="${WORKDIR}/${P}/src"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(gcc-major-version) -lt 4 ]] || ( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ]] ) ; then
			die "Compilation with gcc older than 4.6 is not supported."
		fi
	fi

	if [ ! -d "/usr/local/include/CL" ]; then
		eerror "As a temporary workaround for Bug #521734, a symlink pointing to"
		eerror "OpenCL headers >= 1.2 is needed. A symlink pointing to the CL-1.2"
		eerror "headers, provided by the eselect-opencl package, can be created with"
		eerror ""
		eerror "  ln -s /usr/lib64/OpenCL/global/include/CL-1.2/ /usr/local/include/CL"
		eerror ""
		die "/usr/local/include/CL not found"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENT="$(usex client)"
		-DBUILD_SAMPLE="$(usex examples)"
		-DBUILD_KTEST="$(usex ktest)"
		-DBUILD_PERFORMANCE="$(usex performance)"
		-DBUILD_TEST="$(usex test)"
		-DOPENCL_ROOT="/usr/local/include"
	)
	cmake-utils_src_configure
}
