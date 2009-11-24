# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools
DESCRIPTION="libfac is an extension of Singular-factor to finite fields"

HOMEPAGE="ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Libfac/"

SRC_URI="ftp://www.mathematik.uni-kl.de/pub/Math/Singular/libfac/libfac-3-1-0.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="singular"

DEPEND="singular? ( sci-libs/factory[singular] )
		!singular? ( sci-libs/factory[-singular] )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/libfac"

src_compile() {
	cd "${S}"

	econf --prefix="${D}/usr" \
		$(use_with singular Singular) ||  die "econf failed"

	emake all || die "make failed"
}

src_install() {
	cd "${S}"
	emake install || die "Install failed"
}