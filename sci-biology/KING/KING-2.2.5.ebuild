# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Check family relationship and infer population structure"
HOMEPAGE="https://people.virginia.edu/~wc9c/KING
	https://people.virginia.edu/~wc9c/publications/pdf/BI26_2867.pdf"
SRC_URI="https://people.virginia.edu/~wc9c/KING/KINGcode.tar.gz -> ${P}.tar.gz
	https://people.virginia.edu/~wc9c/KING/manual.html -> ${PN}_relationship_inference.html
	https://people.virginia.edu/~wc9c/KING/kingpopulation.html -> ${PN}.kingpopulation.html"

LICENSE="all-rights-reserved" # Our robust relationship inference algorithm is implemented in a freely available software package
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_compile(){
	$(tc-getCXX) ${CXXFLAGS} -lm -lz -fopenmp -o king *.cpp
}

src_install(){
	newbin {king,KING}
	dodoc "${DISTDIR}"/"${PN}"_relationship_inference.html "${DISTDIR}"/"${PN}".kingpopulation.html
}
