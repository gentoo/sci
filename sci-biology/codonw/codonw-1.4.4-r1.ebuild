# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs versionator

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="Multivariate statistical analysis of codon and amino acid usage"
HOMEPAGE="http://codonw.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/CodonWSourceCode_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/codonW

src_prepare() {
	sed -e 's/$(CC) -c/& -DBSD/' \
		-e 's/$(CFLAGS)  $(objects)/$(CFLAGS) $(LDFLAGS) $(objects)/' \
		-i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin codonw
	# woohoo watch out for collisions
	for i in rscu cu aau raau tidy reader cutab cutot transl bases base3s dinuc cai fop gc3s gc cbi enc; do
		dosym codonw /usr/bin/${i}
	done
	dodoc *.txt
}
