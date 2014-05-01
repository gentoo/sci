# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

MY_PN="${PN/client/perl}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Perl Opal Web Service Client"
HOMEPAGE="http://nbcr.net/software/opal/"
SRC_URI="mirror://sourceforge/opaltoolkit/${MY_P}.tar.gz"

LICENSE="opal"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/SOAP-Lite
	dev-lang/perl
	dev-python/opal-client"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

src_install() {
	insinto ${SITE_LIB}
	doins *.pm || die
	dodoc README etc/* pdb2pqrclient.pl || die
	dohtml docs/* || die
}
