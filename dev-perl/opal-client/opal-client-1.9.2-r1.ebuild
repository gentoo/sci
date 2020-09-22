# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

MY_PN="${PN/client/perl}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Perl Opal Web Service Client"
HOMEPAGE="http://nbcr.net/software/opal/"
SRC_URI="mirror://sourceforge/opaltoolkit/${MY_P}.tar.gz"

LICENSE="opal"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/SOAP-Lite
	dev-python/opal-client
"

S="${WORKDIR}"/${MY_P}

src_install() {
	insinto ${VENDOR_ARCH}
	doins *.pm
	dodoc README etc/* pdb2pqrclient.pl
	dodoc docs/*
}
