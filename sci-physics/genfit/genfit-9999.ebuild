# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils versionator

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/GenFit/GenFit.git"
	KEYWORDS=""
else
	# .zip-snapshot can be recreated by visiting
	# http://sourceforge.net/p/${PN}/code/${COMMIT}/tarball?path=/tags/v$(replace_all_version_separators '-')
	TAG_VER=${PN}-code-1688-tags-v$(replace_all_version_separators '-')
	#SRC_URI="http://sourceforge.net/code-snapshots/svn/g/ge/genfit/code/${TAG_VER}.zip"
	SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${TAG_VER}.zip"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	S=${WORKDIR}/${TAG_VER}
fi

DESCRIPTION="Generic toolkit for track reconstruction in physics experiments"
HOMEPAGE="http://genfit.sourceforge.net/Main.html"

LICENSE="LGPL-3"
SLOT="0"
IUSE="doc examples"

RDEPEND="
	sci-physics/root:=
	dev-libs/boost:="
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )"

src_compile() {
	cmake-utils_src_compile
	use doc      && cmake-utils_src_compile doc
	use examples && cmake-utils_src_compile tests
}

src_install() {
	cmake-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${BUILD_DIR}/bin"
		doins test/makeGeom.C
		doins test/README
	fi
	use doc && dohtml -r doc/html/*
	echo
	elog "Note that there is no support in this ebuild for RAVE yet,"
	elog "which is also not in portage."
	elog "It should be possible to use a local installation of RAVE"
	elog "and set:"
	elog "  export RAVEPATH=<yourRaveDirectory>"
	echo
}
