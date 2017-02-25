# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils versionator

#ESVN_REPO_URI="https://vgm.svn.sourceforge.net/svnroot/${PN}/tags/v$(replace_all_version_separators '-')/${PN}"
#ESVN_PROJECT="${PN}.${PV}"

# .zip-snapshot can be recreated by visiting
# http://sourceforge.net/p/${PN}/code/${COMMIT}/tarball?path=/tags/v$(replace_all_version_separators '-')
TAG_VER="${PN}-code-731-tags-v$(replace_all_version_separators '-')"

DESCRIPTION="Virtual Geometry Model for High Energy Physics Experiments"
HOMEPAGE="http://ivana.home.cern.ch/ivana/VGM.html"
#SRC_URI="http://sourceforge.net/code-snapshots/svn/v/vg/vgm/code/${TAG_VER}.zip"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${TAG_VER}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples +geant4 +root test xml"

RDEPEND="
	sci-physics/clhep:=
	root? ( sci-physics/root:= )
	geant4? ( >=sci-physics/geant-4.9.6[examples?] )
	xml? ( dev-libs/xerces-c )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
	test? ( geant4? ( xml? ( >=sci-physics/geant-4.9.6[gdml] ) ) )"

S=${WORKDIR}/${TAG_VER}/${PN}

src_configure() {
	local mycmakeargs=(
		-DCLHEP_DIR="${EROOT}usr"
		$(cmake-utils_use_with examples)
		$(cmake-utils_use_with geant4)
		$(cmake-utils_use_with root)
		$(cmake-utils_use_with test)
		$(cmake-utils_use_with xml xercesc)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		cd packages
		doxygen || die
	fi
}

src_test() {
	cd "${BUILD_DIR}"/test
	./test_suite.sh || die
}

src_install() {
	cmake-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
	cd doc || die
	dodoc README todo.txt VGMhistory.txt VGM.html VGMversions.html
	use doc && dohtml -r html/*
}
