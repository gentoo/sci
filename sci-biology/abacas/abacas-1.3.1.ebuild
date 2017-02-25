# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Order and orientate DNA contigs even via 6-frame protein alignments"
HOMEPAGE="http://abacas.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/project/abacas/abacas.1.3.1.pl"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl
	sci-biology/mummer"

S="${WORKDIR}"

src_prepare(){
	cp -p "${DISTDIR}"/abacas.1.3.1.pl abacas.pl || die
	sed \
		-i 's#/usr/local/bin/perl#/usr/bin/perl#' \
		-i abacas.pl || die
	eapply_user
}
src_install(){
	dobin abacas.pl
}

pkg_postinst(){
	optfeature "To view the results use Artemis ACT" sci-biology/artemis
}
