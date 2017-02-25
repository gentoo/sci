# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils versionator

if [[ ${PV} == *9999* ]]; then
	inherit subversion
	ESVN_REPO_URI="svn://svn.code.sf.net/p/vgm/code/trunk/vgm"
	KEYWORDS=""
else
	SRC_URI="http://ivana.home.cern.ch/ivana/${PN}.${PV}.tar.gz"
	S="${WORKDIR}/${PN}.${PV}"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Virtual Geometry Model for High Energy Physics Experiments"
HOMEPAGE="http://ivana.home.cern.ch/ivana/VGM.html"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc examples +geant4 +root test xml"

RDEPEND="
	sci-physics/clhep:=
	root? ( sci-physics/root:= )
	geant4? ( >=sci-physics/geant-4.9.6 )
	xml? ( dev-libs/xerces-c )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
	test? ( geant4? ( xml? ( >=sci-physics/geant-4.9.6[gdml] ) ) )"

src_prepare() {
	default
}

src_configure() {
	local mycmakeargs=(
		-DCLHEP_DIR="${EROOT}usr"
		-Dexamples="$(usex examples)"
		-DVGM_INSTALL_EXAMPLES="$(usex examples)"
		-Dgeant4="$(usex geant4)"
		-Droot="$(usex root)"
		-Dtest="$(usex test)"
		-Dxercesc="$(usex xml)"
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
	cd doc || die
	dodoc README todo.txt VGMhistory.txt VGM.html VGMversions.html
	use doc && dohtml -r html/*
}
