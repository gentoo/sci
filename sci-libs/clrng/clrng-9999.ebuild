# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

MY_PN="clRNG"

DESCRIPTION="A library for uniform random number generation in OpenCL"
HOMEPAGE="https://github.com/clMathLibraries/clRNG"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/clMathLibraries/${MY_PN}.git git://github.com/clMathLibraries/${MY_PN}.git"
	S="${WORKDIR}/${P}/src"
else
	SRC_URI="https://github.com/clMathLibraries/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}/src"
fi

LICENSE="BSD-2 BSD"
SLOT="0"
IUSE="+client test"

RDEPEND="
	>=sys-devel/gcc-4.8:*
	virtual/opencl
	|| ( >=dev-util/amdapp-2.9 dev-util/intel-ocl-sdk )
	dev-libs/boost
	"
DEPEND="${RDEPEND}"

# The tests only get compiled to an executable named Test, which is not recogniozed by cmake.
# Therefore src_test() won't execute any test.
RESTRICT="test"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(gcc-major-version) -lt 4 ]] || ( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 8 ]] ) ; then
			die "Compilation with gcc older than 4.8 is not supported."
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build client CLIENT)
		$(cmake-utils_use_build test TEST)
	)
	cmake-utils_src_configure
}
