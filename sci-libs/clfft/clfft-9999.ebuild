# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="clFFT"

DOCS_BUILDER="doxygen"
DOCS_DIR="../docs"
DOCS_CONFIG_NAME="${MY_PN}.doxy"

inherit cmake docs git-r3

DESCRIPTION="Library containing FFT functions written in OpenCL"
HOMEPAGE="https://github.com/clMathLibraries/clFFT"
EGIT_REPO_URI="
	https://github.com/clMathLibraries/${MY_PN}.git
	git://github.com/clMathLibraries/${MY_PN}.git
"
EGIT_BRANCH="develop"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="callback_client +client test"

RDEPEND="
	virtual/opencl
	dev-libs/boost"
DEPEND="${RDEPEND}"
BDEPEND="test? (
	dev-cpp/gtest
	sci-libs/fftw:3.0
)"

# The tests only get compiled to an executable named Test, which is not recogniozed by cmake.
# Therefore src_test() won't execute any test.
RESTRICT="test"

S="${WORKDIR}/${P}/src"

src_configure() {
	local mycmakeargs=(
		-DBUILD_CALLBACK_CLIENT="$(usex callback_client)"
		-DBUILD_CLIENT="$(usex client)"
		-DBUILD_TEST="$(usex test)"
		-DBoost_USE_STATIC_LIBS=OFF
	)
	cmake_src_configure
}

src_compile() {
	docs_compile
	cmake_src_compile
}
