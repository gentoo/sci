# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Order and orientate DNA contigs even via 6-frame protein alignments, design primers for gap closing"
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
	sed -i 's#/usr/local/bin/perl#/usr/bin/perl#' -i abacas.pl || die
}
src_install(){
	dobin abacas.pl
}

pkg_postinst(){
	einfo "To view the results use Artemis ACT (sci-biology/artemis)"
}
