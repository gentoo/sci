# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator toolchain-funcs

MY_PV=$(replace_all_version_separators '-')

DESCRIPTION="Find shared segments of Identity by Descent (IBD) between pairs of individuals"
HOMEPAGE="http://www.cs.columbia.edu/~gusev/germline
	http://genome.cshlp.org/content/19/2/318.full"
SRC_URI="http://www.cs.columbia.edu/~gusev/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/boost"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}-${MY_PV}

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
