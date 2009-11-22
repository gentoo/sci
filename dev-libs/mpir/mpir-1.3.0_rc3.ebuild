# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils versionator autotools

DESCRIPTION="MPIR is a library for arbitrary precision integer arithmetic derived from version 4.2.1 of gmp"
HOMEPAGE="http://www.mpir.org/"
SRC_URI="http://www.mpir.org/${PN}-$(replace_version_separator 3 -).tar.gz"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nocxx cpudetection"

# Beware: cpudetection aka fat binaries only works on x86/amd64
# When we enable more cpus we will have to carefully filter.

DEPEND="dev-lang/yasm"
RDEPEND=""

src_prepare(){
	epatch "${FILESDIR}/${P}-yasm.patch"
	eautoreconf
}

src_configure() {
	# causes problems on amd64
	unset ABI

# beware that cpudetection aka fat binaries is x86/amd64 only.
# It will need to be filtered when extended to other archs
	econf \
		$(use_enable !nocxx cxx) \
		$(use_enable cpudetection fat) \
		|| "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README NEWS
}
