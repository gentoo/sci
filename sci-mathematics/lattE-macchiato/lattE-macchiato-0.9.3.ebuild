# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils flag-o-matic

DESCRIPTION="lattE-macchiato consists of tools for lattice point enumeration"
SRC_URI="http://www.math.ucdavis.edu/~mkoeppe/latte/download/latte-for-tea-too-1.2-mk-0.9.3.tar.gz"
#	mirror://gentoo/${P}-src.tar.bz2

HOMEPAGE="http://www.math.ucdavis.edu/~mkoeppe/latte/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	dev-libs/gmp[cxx]
	>=dev-libs/ntl-5.4.2
	sci-mathematics/4ti2
	>=sci-libs/cdd+-077a
	>=sci-mathematics/glpk-4.13
	>=sci-libs/cddlib-094f"
RDEPEND="${DEPEND}"

S="${WORKDIR}/latte-for-tea-too-1.2-mk-0.9.3"

# For now LattE builds an internal version of Lidia.
# This will not be split off for now because it is heavily patched
# and based on a version that was not even released.

src_prepare() {
	epatch "${FILESDIR}/buildpackages.patch"

	eautoreconf
}

src_install() {
	# install
	cd "${S}"/lidia-2.2.1-pre1+svn-1069+lattepatches-0.1/
	emake DESTDIR="${D}" install || die "Install failed"
	cd "${S}"/latte-1.2-mk-0.9.3/
	emake DESTDIR="${D}" install || die "Install failed"
	# ... and get rid of minimize which is provided by 4ti2:
	rm "${D}"/usr/bin/minimize || die "Removing minimize failed"
}
