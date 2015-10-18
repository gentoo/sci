# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils versionator git-r3

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI=" http://root.cern.ch/git/geant4_vmc.git"
	KEYWORDS=""
else
	MPV=$(get_version_component_range 2-)
	SRC_URI="ftp://root.cern.ch/root/vmc/geant4_vmc.${MPV}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Virtual Monte Carlo Geant4 implementation"
HOMEPAGE="http://root.cern.ch/root/vmc/VirtualMC.html"

LICENSE="GPL-2"
SLOT="4"
IUSE="doc examples geant3 +g4root +mtroot vgm test"

RDEPEND="
	sci-physics/root:=
	>=sci-physics/geant-4.9.6[opengl,geant3?]
	vgm? ( >=sci-physics/vgm-4.00 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	local mycmakeargs=(
			$(cmake-utils_use vgm Geant4VMC_USE_VGM)
			$(cmake-utils_use geant3 Geant4VMC_USE_GEANT4_G3TOG4)
			$(cmake-utils_use g4root Geant4VMC_USE_G4Root)
			$(cmake-utils_use mtroot Geant4VMC_USE_MTRoot)
			$(cmake-utils_use test Geant4VMC_BUILD_EXAMPLES)
			$(cmake-utils_use examples Geant4VMC_INSTALL_EXAMPLES)
			)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	local dirs="source"
	use g4root && dirs+=" g4root "
	use mtroot && dirs+=" mtroot "
	use examples && dirs+=" examples "
	local d
	for d in ${dirs}; do
		pushd ${d} > /dev/null || die
		if use doc; then
			doxygen || die
		fi
		popd > /dev/null
	done
}

src_test() {
	cd examples || die
	./test_suite.sh --g3=off --builddir="${BUILD_DIR}" || die
	./test_suite_exe.sh --g3=off --builddir="${BUILD_DIR}" || die
}

src_install() {
	cmake-utils_src_install
	dodoc README history
	use doc && dohtml -r Geant4VMC.html doc/*
}
