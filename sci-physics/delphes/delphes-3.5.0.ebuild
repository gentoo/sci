# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake

DESCRIPTION="Delphes performs a fast multipurpose detector response simulation."
HOMEPAGE="
	https://github.com/delphes/delphes
	http://cp3.irmp.ucl.ac.be/projects/delphes
"

MY_P=${PN^}-${PV}

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/delphes/delphes"
else
	SRC_URI="http://cp3.irmp.ucl.ac.be/downloads/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
	# Alternatively https://github.com/delphes/delphes/archive/refs/tags/3.5.0.tar.gz
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
DEPEND="
	sci-physics/root:=[opengl]
	sci-physics/pythia:8=
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	cmake_src_prepare
	sed -i "s#DESTINATION cards#DESTINATION share/delphes/cards#g" cards/CMakeLists.txt || die
	sed -i "s#DESTINATION examples#DESTINATION share/delphes/examples#g" examples/CMakeLists.txt || die
	sed -i "s#DESTINATION lib#DESTINATION $(get_libdir)#g" CMakeLists.txt || die
	sed -i "s#DESTINATION lib#DESTINATION $(get_libdir)#g" modules/CMakeLists.txt || die
	sed -i "s#DESTINATION lib#DESTINATION $(get_libdir)#g" classes/CMakeLists.txt || die
	sed -i "s#DESTINATION lib#DESTINATION $(get_libdir)#g" display/CMakeLists.txt || die
}
