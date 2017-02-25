# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Population genetics analysis"
HOMEPAGE="http://genepop.curtin.edu.au/ http://kimura.univ-montp2.fr/~rousset/Genepop.htm"
SRC_URI="http://kimura.univ-montp2.fr/%7Erousset/GenepopV4.tar.gz -> ${P}.tar.gz
	http://kimura.univ-montp2.fr/%7Erousset/Genepop.pdf -> ${PN}.pdf"

LICENSE="CeCILL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_prepare() {
	gzip -dc sources.tar.gz | tar xf - || die
	mv Cpp/* . || die
	rmdir Cpp || die
	cat >> CMakeLists.txt <<- EOF
	cmake_minimum_required (VERSION 2.6)
	project (${PN} CXX)

	set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -DNO_MODULES")

	add_executable(Genepop GenepopS.cpp)
	install(TARGETS Genepop DESTINATION bin)
	EOF
	cmake-utils_src_prepare
	default
}

src_install(){
	cmake-utils_src_install
	dodoc "${DISTDIR}"/"${PN}".pdf
}
