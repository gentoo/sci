# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A GUI application written in Perl to help design
primers for standard PCR, bisulphite PCR and Real-time PCR"
HOMEPAGE="http://perlprimer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-perl/perl-tk
	dev-perl/libwww-perl"

src_unpack() {

	unpack ${A}
	cd "${S}"
	sed -i -e "s|\(\"\$HOME\".\"gcg.*\"\)|\"\/usr\/share\/${P}\/\".\"gcg.*\"|" perlprimer.pl || die "Sed failed!"
}

# TODO: figure out why right-clicking on the sequence doesn't produce a stable menu.
# see if upstream still exists, point them at the new gcg file.

src_install() {

	exeinto /usr/bin
	doexe "${S}"/perlprimer.pl
	insinto /usr/share/${P}
	doins ${FILESDIR}/gcg.801
	dodoc Changelog  ReadMe.txt
	dohtml -r tutorial_files tutorial.html
}
