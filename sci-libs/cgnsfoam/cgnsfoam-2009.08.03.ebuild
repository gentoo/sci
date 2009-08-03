# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib

DESCRIPTION="cgnsfoam is a conversion tool from cgns to openfoam format"
HOMEPAGE="http://openfoam-extend.sourceforge.net"
SRC_URI="http://ppa.launchpad.net/cae-team/ppa/ubuntu/pool/main/c/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

OF_PV="1.5"

DEPEND="sci-libs/cgnslib
	sci-libs/libcgnsoo
	=sci-libs/openfoam-src-${OF_PV}*"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/"${PN}"-compile.patch
}

src_compile() {
	source /usr/$(get_libdir)/OpenFOAM/OpenFOAM-${OF_PV}/etc/bashrc
	export FOAM_USER_APPBIN=${S}/bin/
	sh Allwmake
}

src_install() {
	into "/usr/$(get_libdir)/OpenFOAM/OpenFOAM-${OF_PV}/applications"
	dobin bin/*
}
