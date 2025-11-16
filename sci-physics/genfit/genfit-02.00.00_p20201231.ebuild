# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/GenFit/GenFit.git"
else
	EGIT_COMMIT="c3546c073e732abc942a08430b6ca3cb36f5339e"
	MY_PN="GenFit"
	SRC_URI="https://github.com/GenFit/GenFit/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${EGIT_COMMIT}"
fi

DESCRIPTION="Generic toolkit for track reconstruction in physics experiments"
HOMEPAGE="https://github.com/GenFit/GenFit"

LICENSE="LGPL-3"
SLOT="0"

IUSE="doc"

PATCHES=(
	"${FILESDIR}"/"${P}"-CMake-version.patch
	"${FILESDIR}"/"${P}"-FindROOT.patch
)

RDEPEND="
	sci-physics/root:=
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install
	if use doc; then
		docinto html
		dodoc -r doc/html/.
	fi
	echo
	elog "Note that there is no support in this ebuild for RAVE yet,"
	elog "which is also not in portage."
	elog "It should be possible to use a local installation of RAVE"
	elog "and set:"
	elog "  export RAVEPATH=<yourRaveDirectory>"
	echo
}
