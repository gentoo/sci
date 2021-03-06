# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DEB_PATCHLVL=10

DESCRIPTION="Maximum likelihood phylogenetic tree builder for DNA sequences"
HOMEPAGE="https://directory.fsf.org/wiki/FastDNAml"
SRC_URI="
	mirror://debian/pool/main/f/fastdnaml/${PN}_${PV%%_p${DEB_PATCHLVL}}.orig.tar.gz
	mirror://debian/pool/main/f/fastdnaml/${PN}_${PV/_p/-}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"/fastDNAml_${PV%_p*}

src_prepare() {
	mv ../debian . || die
	default
	eapply debian/patches/*patch
}

src_install() {
	dodir /usr/{bin,lib/fastdnaml/bin}
	default
	dodoc docs/*
	doman debian/fastDNAml.1
}
