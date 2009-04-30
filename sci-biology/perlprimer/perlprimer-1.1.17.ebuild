# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="GUI application written in Perl to design primers for standard PCR, bisulphite PCR and Real-time PCR"
HOMEPAGE="http://perlprimer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-perl/perl-tk
	dev-perl/libwww-perl
	>=sci-biology/rebase-904"

src_unpack() {

	unpack ${A}
	cd "${S}"
	sed -e \
		"s:\(\"\$HOME\".\"gcg.*\"\):\"/usr/share/rebase/gcg.*\":g" \
		-i perlprimer.pl || die "Sed failed!"
}

# TODO: figure out why right-clicking on the sequence doesn't produce a stable menu.
# see if upstream still exists, point them at the new gcg file.

src_install() {
	newbin perlprimer.pl ${PN} || die
	dodoc Changelog  ReadMe.txt
	dohtml -r tutorial_files tutorial.html
}
