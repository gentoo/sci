# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Multivariate statistical analysis of codon and amino acid usage"
HOMEPAGE="https://codonw.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/CodonWSourceCode_${PV//./_}.tar.gz
		http://codonw.sourceforge.net/JohnPedenThesisPressOpt_water.pdf"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/codonW"

src_prepare() {
	sed \
		-e 's/$(CC) -c/& -DBSD/' \
		-e 's/$(CFLAGS)  $(objects)/$(CFLAGS) $(LDFLAGS) $(objects)/' \
		-i Makefile || die
	default
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	local i
	dobin ${PN}
	# woohoo watch out for collisions
	for i in rscu cu aau raau tidy reader cutab cutot transl bases base3s dinuc cai fop gc3s gc cbi enc; do
		dosym codonw /usr/bin/${i}-${PN}
	done
	dodoc *.txt "${DISTDIR}"/JohnPedenThesisPressOpt_water.pdf
}
