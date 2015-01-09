# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="EST clustering tools (estcluster, usage counter, revcomp and translate)"
HOMEPAGE="http://www.ebi.ac.uk/~guy/estate"
SRC_URI="http://www.ebi.ac.uk/~guy/estate/estate.tar.gz
	http://www.ebi.ac.uk/~guy/estate/thesis.ps.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/estate

src_prepare(){
	sed -e "s/^CC/#CC/" -e "s/^LDFLAGS/#LDFLAGS/" -e "s/^CFLAGS/#CFLAGS/" -e "s/LDFLAGS/CFLAGS/" -i src/Makefile || die
}

src_install(){
	dobin bin/*
	doman doc/man/man1/*.1 doc/man/man7/*.7
	insinto /usr/share/ESTate/etc
	doins etc/ESTaterc
	dodoc ANNOUNCE.txt README.txt
	dodoc "${DISTDIR}"/thesis.ps.gz
	einfo "Additionally you may want to install sci-biology/wcd which can be used by ESTate"
}
