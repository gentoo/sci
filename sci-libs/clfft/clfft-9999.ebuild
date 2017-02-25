# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

MY_PN="clFFT"

DESCRIPTION="Library containing FFT functions written in OpenCL"
HOMEPAGE="https://github.com/clMathLibraries/clFFT"
EGIT_REPO_URI="
	https://github.com/clMathLibraries/${MY_PN}.git
	git://github.com/clMathLibraries/${MY_PN}.git
	"
EGIT_BRANCH="develop"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="callback_client +client examples test"

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

S="${WORKDIR}/${P}/src"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(gcc-major-version) -lt 4 ]] || ( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ]] ) ; then
			die "Compilation with gcc older than 4.6 is not supported."
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CALLBACK_CLIENT="$(usex callback_client)"
		-DBUILD_CLIENT="$(usex client)"
		-DBUILD_SAMPLE="$(usex examples)"
		-DBUILD_TEST="$(usex test)"
		-DBoost_USE_STATIC_LIBS=OFF
	)
	cmake-utils_src_configure
}
