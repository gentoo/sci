# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="Multivariate statistical analysis of codon and amino acid usage"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/CodonWSourceCode_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/codonW"

src_install() {
	dobin codonw || die
	# woohoo watch out for collisions
	for i in rscu cu aau raau tidy reader cutab cutot transl bases base3s dinuc cai fop gc3s gc cbi enc; do
		dosym codonw /usr/bin/${i} || die
	done
	dodoc *.txt
}
