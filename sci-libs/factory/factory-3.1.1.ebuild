# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools versionator

MY_PV=$(replace_all_version_separators '-')

DESCRIPTION="factory is a C++ library for representing multivariate polynomials"
HOMEPAGE="http://www.mathematik.uni-kl.de/pub/Math/Singular/Factory"
SRC_URI="ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Factory/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="singular"

DEPEND="dev-libs/gmp
		>=dev-libs/ntl-5.4.1"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

RESTRICT="mirror"

src_compile() {
	econf --prefix="${D}/usr" \
		$(use_with singular Singular) ||  die "econf failed"

	emake all || die "make failed"
}

src_install() {
	# Needs -j1 because of race conditions during directory creation
	emake -j1 install || die "Install failed"
}