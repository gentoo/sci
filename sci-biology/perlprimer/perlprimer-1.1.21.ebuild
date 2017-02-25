# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Primers design for standard PCR, bisulphite PCR and Real-time PCR"
HOMEPAGE="http://perlprimer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-perl/Tk
	dev-perl/libwww-perl
	>=sci-biology/rebase-904"

src_prepare() {
	sed \
		-e "s:\(\"\$HOME\".\"gcg.*\"\):\"/usr/share/rebase/gcg.*\":g" \
		-i perlprimer.pl || die "Sed failed!"
}

# TODO: figure out why right-clicking on the sequence doesn't produce a stable menu.
# see if upstream still exists, point them at the new gcg file.

src_install() {
	newbin perlprimer.pl ${PN}
	dodoc Changelog  ReadMe.txt
	docinto html
	dodoc -r tutorial_files tutorial.html
}
