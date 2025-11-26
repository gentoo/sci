# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit cmake fortran-2 python-single-r1

MY_PV=${PV//_/-}
MY_P=${P//_/-}

DESCRIPTION="Higher Order Perturbative Parton Evolution Toolkit"
HOMEPAGE="
	https://hoppet.hepforge.org/
	https://github.com/gavinsalam/hoppet
"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hoppet-code/hoppet"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/hoppet-code/hoppet/archive/refs/tags/${MY_P}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${MY_P}"
	KEYWORDS="~amd64"
fi

SLOT="0"
LICENSE="GPL-3+"
IUSE="exact-coef examples python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"
DEPEND="
	python? (
		${PYTHON_DEPS}
		dev-lang/swig
	)
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	fortran-2_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DHOPPET_USE_EXACT_COEF=$(usex exact-coef)
		-DHOPPET_BUILD_PYINTERFACE=$(usex python)
		-DHOPPET_BUILD_EXAMPLES=$(usex examples)
		-DHOPPET_ENABLE_TESTING=$(usex test)
		-DHOPPET_BUILD_BENCHMARK=OFF
		-DHOPPET_ENABLE_DEBUG=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use examples; then
		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	find "${ED}" -name '*.la' -delete || die
}
