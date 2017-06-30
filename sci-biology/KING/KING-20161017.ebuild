# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Check family relationship and infer population structure"
HOMEPAGE="http://people.virginia.edu/~wc9c/KING
	http://people.virginia.edu/~wc9c/publications/pdf/BI26_2867.pdf"
SRC_URI="http://people.virginia.edu/~wc9c/KING/KINGcode.tar.gz -> ${P}.tar.gz
	http://people.virginia.edu/~wc9c/KING/manual.html -> ${PN}_relationship_inference.html
	http://people.virginia.edu/~wc9c/KING/kingpopulation.html -> ${PN}.kingpopulation.html"

LICENSE="all-rights-reserved" # Our robust relationship inference algorithm is implemented in a freely available software package
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_compile(){
	$(tc-getCXX) ${CXXFLAGS} -lm -lz -fopenmp -o king *.cpp
}

src_install(){
	newbin {king,KING}
	insinto /usr/share/doc/"${PN}"
	dodoc "${DISTDIR}"/"${PN}"_relationship_inference.html "${DISTDIR}"/"${PN}".kingpopulation.html
}
