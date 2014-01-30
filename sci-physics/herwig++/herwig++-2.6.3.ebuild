# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils

MYP=Herwig++-${PV}

DESCRIPTION="High-Energy Physics event generator"
HOMEPAGE="http://herwig.hepforge.org/"
SRC_URI="http://www.hepforge.org/archive/herwig/${MYP}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fastjet"

DEPEND="dev-libs/boost
	virtual/fortran
	sci-libs/gsl
	sci-physics/LoopTools
	dev-lang/perl
	=sci-physics/thepeg-1.8.3
	fastjet? ( sci-physics/fastjet )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch "${FILESDIR}/${P}-looptools.patch"
	find -name 'Makefile.am' -exec sed -i '1ipkgdatadir=$(datadir)/herwig++' {} \; \
		|| die "changing pkgdatadir name failed"
	eautoreconf
}

src_configure() {
	econf \
		--disable-silent-rules \
		--with-boost="${EPREFIX}"/usr \
		--with-thepeg="${EPREFIX}"/usr \
		$(use_with fastjet fastjet "${EPREFIX}"/usr)
}

pkg_preinst () {
	sed -i "s%${ED}%%g" "${ED}"/usr/share/herwig++/defaults/PDF.in || die
	sed -i "s%${ED}%%g" "${ED}"/usr/share/herwig++/HerwigDefaults.rpo || die
}
