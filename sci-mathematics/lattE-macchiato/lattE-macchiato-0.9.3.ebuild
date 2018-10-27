# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils flag-o-matic

DESCRIPTION="lattE-macchiato consists of tools for lattice point enumeration"
HOMEPAGE="http://www.math.ucdavis.edu/~mkoeppe/latte/"
SRC_URI="http://www.math.ucdavis.edu/~mkoeppe/latte/download/latte-for-tea-too-1.2-mk-0.9.3.tar.gz"
#	mirror://gentoo/${P}-src.tar.bz2

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/gmp:0=[cxx]
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
	default
	cd "${S}"/latte-1.2-mk-0.9.3/ || die
	default
	# ... and get rid of minimize which is provided by 4ti2:
	rm "${ED}"/usr/bin/minimize || die "Removing minimize failed"
}
