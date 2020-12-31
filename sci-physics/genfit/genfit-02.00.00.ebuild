# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOCS_BUILDER="doxygen"
DOCS_DIR="doc"

inherit cmake docs

TAG_VER=${PN}-code-1688-tags-v${PV//./-}

DESCRIPTION="Generic toolkit for track reconstruction in physics experiments"
HOMEPAGE="http://genfit.sourceforge.net/Main.html" # no https
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${TAG_VER}.zip"

LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="examples"

RDEPEND="
	sci-physics/root:=
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${TAG_VER}

src_compile() {
	cmake_src_compile
	docs_compile
	use examples && cmake_src_compile tests
}

src_install() {
	cmake_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${BUILD_DIR}/bin"
		doins test/makeGeom.C
		doins test/README
	fi
	echo
	elog "Note that there is no support in this ebuild for RAVE yet,"
	elog "which is also not in portage."
	elog "It should be possible to use a local installation of RAVE"
	elog "and set:"
	elog "  export RAVEPATH=<yourRaveDirectory>"
	echo
}
