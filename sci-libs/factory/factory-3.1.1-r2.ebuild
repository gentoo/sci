# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils versionator

MY_PV=$(replace_all_version_separators '-')

DESCRIPTION="C++ library for representing multivariate polynomials"
HOMEPAGE="http://www.mathematik.uni-kl.de/pub/Math/Singular/Factory"
SRC_URI="ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Factory/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="singular static-libs"

DEPEND="
	dev-libs/gmp:0=
	>=dev-libs/ntl-5.4.1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( README NEWS )
PATCHES=( "${FILESDIR}"/${P}-gentoo.diff )

pkg_setup() {
	tc-export CC CPP CXX
}

src_configure() {
	myeconfargs=( $(use_with singular Singular) )

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	# Passing --disable-static to configure won't disable the build of static libs,
	# as libtool isn't used. Therefore the static libs are deleted after installed to ${D}.
	use !static-libs || find "${ED}" -type f -name "*.a" -delete || die
}
