# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/amos/amos-2.0.8.ebuild,v 1.2 2009/03/15 17:58:50 maekke Exp $

EAPI="2"

inherit versionator

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="SHort Read Mapping Package"
HOMEPAGE="http://compbio.cs.toronto.edu/shrimp/"
SRC_URI="http://compbio.cs.toronto.edu/shrimp/releases/SHRiMP_${MY_PV}.src.tar.gz"

LICENSE="as-is"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/SHRiMP_${MY_PV}"

# "When building with gcc, execute the following: gmake CXX="g++" CXXFLAGS="-O3 -mmmx -msse -msse2" GCC 4 users should also supply appropriate -ftree-vectorize and -march flags."

src_configure() {
	sed -i '/CXXFLAGS=/ s/-Werror//' "${S}/Makefile" || die
	sed -i '1 a #include <stdlib.h>' "${S}/common/dag_glue.cpp" || die
}

src_install() {
	rm bin/README
	dobin bin/* || die
	insinto /usr/share/${PN}
	doins -r utils || die
	dodoc HISTORY README TODO
}
