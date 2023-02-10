# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

DESCRIPTION="Order and orientate DNA contigs even via 6-frame protein alignments"
HOMEPAGE="http://abacas.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/project/abacas/abacas.${PV}.pl"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl
	sci-biology/mummer"

S="${WORKDIR}"

src_prepare(){
	cp -p "${DISTDIR}"/abacas.${PV}.pl abacas.pl || die
	sed \
		-i 's#/usr/local/bin/perl#/usr/bin/perl#' \
		-i abacas.pl || die
	default
}
src_install(){
	dobin abacas.pl
}

pkg_postinst(){
	optfeature "To view the results use Artemis ACT" sci-biology/artemis
}
