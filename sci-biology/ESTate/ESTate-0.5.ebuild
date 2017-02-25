# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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

src_install(){
	# prevent file collision with sci-biology/hmmer-2.3.2
	newbin bin/{revcomp,revcomp_ESTate}
	rm bin/revcomp || die
	newbin bin/{translate,translate_ESTate}
	rm bin/translate || die
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
