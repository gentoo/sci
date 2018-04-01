# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Population genetics analysis"
HOMEPAGE="https://genepop.curtin.edu.au/ https://kimura.univ-montp2.fr/~rousset/Genepop.htm"
SRC_URI="https://kimura.univ-montp2.fr/%7Erousset/GenepopV4.tar.gz -> ${P}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_prepare() {
	gzip -dc sources.tar.gz | tar xf - || die
	rm -f exe.zip || die
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
	mv "${ED}"/usr/bin/Genepop "${ED}"/usr/bin/genepop || die
	newdoc Genepop.pdf genepop.pdf
	insinto /usr/share/"${PN}"
	doins examples.zip
}
