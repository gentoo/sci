# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="complete x86/x64 JIT-Assembler for C++ language"
HOMEPAGE="https://asmjit.com/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/asmjit/asmjit"
else
	COMMIT=b49d685cd9e2e4488f55ce6004306a79bdea056b
	SRC_URI="https://github.com/asmjit/asmjit/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="~amd64"
fi

SLOT="0"
LICENSE="BSD"
IUSE="natvis static-libs test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DASMJIT_EMBED=$(usex static-libs)
		-DASMJIT_BUILD_X86=ON
		-DASMJIT_NO_NATVIS=$(usex natvis)
		-DASMJIT_TEST=$(usex test)
	)
	cmake_src_configure
}
