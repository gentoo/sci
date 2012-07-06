# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MYP=ThePEG-${PV}

DESCRIPTION="Toolkit for High Energy Physics Event Generation"
HOMEPAGE="http://home.thep.lu.se/ThePEG/"
SRC_URI="http://www.hepforge.org/archive/thepeg/${MYP}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hepmc java lhapdf test zlib"

DEPEND="sci-libs/gsl
	dev-lang/perl
	hepmc? ( sci-physics/hepmc )
	java? ( virtual/jre )
	lhapdf? ( sci-physics/lhapdf )
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}
	test? ( sys-process/time )"

S="${WORKDIR}/${MYP}"

pkg_setup() {
	echo
	elog "There is an extra option on package Rivet not yet in Gentoo:"
	elog "You can use the env variable EXTRA_ECONF variable for this:"
	elog "EXTRA_ECONF=\"--with-rivet=DIR\""
	elog "where DIR - location of Rivet installation"
	echo
}

src_configure() {
	econf \
		--disable-silent-rules \
		$(use_with hepmc hepmc "${EPREFIX}"/usr) \
		$(use_with java javagui) \
		$(use_with lhapdf LHAPDF "${EPREFIX}"/usr) \
		$(use_with zlib zlib "${EPREFIX}"/usr)
}
