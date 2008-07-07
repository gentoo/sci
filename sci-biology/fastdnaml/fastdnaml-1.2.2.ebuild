# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DEB_PATCHLVL=8

DESCRIPTION="Maximum likelihood phylogenetic tree builder for DNA sequences"
HOMEPAGE="http://directory.fsf.org/project/fastDNAml/"
SRC_URI="mirror://debian/pool/main/f/fastdnaml/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/f/fastdnaml/${PN}_${PV}-${DEB_PATCHLVL}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/fastDNAml_${PV}" "${WORKDIR}/${P}"
	epatch "${WORKDIR}/${PN}_${PV}-${DEB_PATCHLVL}.diff"
}

src_install() {
	mkdir -p "${D}"/usr/{bin,lib/fastdnaml/bin} || die
	emake DESTDIR="${D}" install || die
	dodoc docs/*
	doman debian/fastDNAml.1
}
