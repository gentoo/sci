# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

MY_PN="clFFT"

DESCRIPTION="Library containing FFT functions written in OpenCL"
HOMEPAGE="https://github.com/clMathLibraries/clFFT"
SRC_URI="https://github.com/clMathLibraries/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+client examples test"

RDEPEND="
	>=sys-devel/gcc-4.6:*
	virtual/opencl
	dev-libs/boost"
DEPEND="${RDEPEND}"
#	test? (
#		dev-cpp/gtest
#		sci-libs/fftw:3.0
#	)"

# The tests only get compiled to an executable named Test, which is not recogniozed by cmake.
# Therefore src_test() won't execute any test.
RESTRICT="test"

S="${WORKDIR}/${MY_PN}-${PV}/src"

PATCHES=(
	"${FILESDIR}/${P}"-Install-cmake-configuration-to-lib-cmake-clFFT.patch
	"${FILESDIR}/${P}"-Install-examples-to-share-clFFT-examples.patch
)

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
		$(cmake-utils_use_build examples EXAMPLES)
		$(cmake-utils_use_build test TEST)
	)
	cmake-utils_src_configure
}
