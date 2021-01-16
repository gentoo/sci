# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="lattE-macchiato consists of tools for lattice point enumeration"
HOMEPAGE="https://www.math.ucdavis.edu/~mkoeppe/latte/"
#SRC_URI="https://www.math.ucdavis.edu/~mkoeppe/latte/download/latte-for-tea-too-1.2-mk-${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="latte-for-tea-too-1.2-mk-${PV}.tar.gz"
# ERROR: cannot verify www.math.ucdavis.edu's certificate, issued by ‘CN=InCommon RSA Server CA,OU=InCommon,O=Internet2,L=Ann Arbor,ST=MI,C=US’:
# Unable to locally verify the issuer's authority.
# To connect to www.math.ucdavis.edu insecurely, use `--no-check-certificate'.
RESTRICT="fetch"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""

DEPEND="
	dev-libs/gmp:0=[cxx]
	>=dev-libs/ntl-5.4.2
	sci-mathematics/4ti2
	>=sci-libs/cdd+-077a
	>=sci-mathematics/glpk-4.13
	>=sci-libs/cddlib-094f"
RDEPEND="${DEPEND}"

S="${WORKDIR}/latte-for-tea-too-1.2-mk-${PV}"

# For now LattE builds an internal version of Lidia.
# This will not be split off for now because it is heavily patched
# and based on a version that was not even released.

PATCHES=(
	"${FILESDIR}/buildpackages.patch"
)

pkg_nofetch() {
	einfo "Please download: https://www.math.ucdavis.edu/~mkoeppe/latte/download/latte-for-tea-too-1.2-mk-${PV}.tar.gz"
	einfo "and place it in your DISTDIR"
}

src_prepare() {
	default

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
