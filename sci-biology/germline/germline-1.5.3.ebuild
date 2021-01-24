# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Find shared segments of Identity by Descent (IBD) between pairs of individuals"
HOMEPAGE="http://gusevlab.org/projects/germline/
	http://genome.cshlp.org/content/19/2/318.full"
SRC_URI="http://gusevlab.org/projects/${PN}/release/${PN}-${PV//./-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/boost"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}-${PV//./-}

src_prepare(){
	sed -e "s/-O3 /${CXXFLAGS} /;s/g++/$(tc-getCXX)/" -i Makefile || die
	sed -e "s#diff -q -s test/expected.match test/generated.match#diff -q -s test/expected.match test/generated.match || cat test/generated.err#" -i Makefile || die
	sed -e "s/^all: clean germline bmatch test/all: clean germline bmatch/" -i Makefile || die
	default
}

src_install(){
	dobin germline parse_bmatch
	dodoc README
}
