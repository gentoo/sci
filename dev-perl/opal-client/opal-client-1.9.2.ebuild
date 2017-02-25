# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit perl-module python-single-r1

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
	dev-python/opal-client[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

src_install() {
	insinto ${SITE_LIB}
	doins *.pm
	dodoc README etc/* pdb2pqrclient.pl
	docinto html
	dodoc docs/*
}
