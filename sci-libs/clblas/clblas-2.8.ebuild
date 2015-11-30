# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

MY_PN="clBLAS"

DESCRIPTION="A software library containing BLAS routines for OpenCL"
HOMEPAGE="https://github.com/clMathLibraries/clBLAS"
SRC_URI="https://github.com/clMathLibraries/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
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

S="${WORKDIR}/${MY_PN}-${PV}/src"

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
		$(cmake-utils_use_build client CLIENT)
		$(cmake-utils_use_build examples SAMPLE)
		$(cmake-utils_use_build ktest KTEST)
		$(cmake-utils_use_build performance PERFORMANCE)
		$(cmake-utils_use_build test TEST)
		-DOPENCL_ROOT="/usr/local/include"
	)
	cmake-utils_src_configure
}
