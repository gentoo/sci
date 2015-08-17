# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="ORF finding despite frameshifts, EST clustering"
HOMEPAGE="http://www.ebi.ac.uk/~guy/estate"
SRC_URI="
	http://www.ebi.ac.uk/~guy/estate/estate.tar.gz
	http://www.ebi.ac.uk/~guy/estate/thesis.ps.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}"/estate

src_prepare(){
	sed \
		-e "s/^CC/#CC/" \
		-e "s/^LDFLAGS/#LDFLAGS/" \
		-e "s/^CFLAGS/#CFLAGS/" \
		-e "s/LDFLAGS/CFLAGS/" \
		-i src/Makefile || die
}

# Detected file collision(s) versus sci-biology/hmmer-2.3.2-r2:
#  * sci-biology/ESTate-0.5:0::science
#  *      /usr/bin/revcomp
#  *      /usr/bin/translate

src_install(){
	dobin bin/*
	doman doc/man/man1/*.1 doc/man/man7/*.7

	insinto /usr/share/ESTate/etc
	doins etc/ESTaterc

	insinto /usr/share/ESTate/example
	doins example/embl59* example/drosophila*

	dodoc ANNOUNCE.txt README.txt "${DISTDIR}"/thesis.ps.gz
}

pkg_postinst() {
	optfeature "additional features" sci-biology/wcd
}
