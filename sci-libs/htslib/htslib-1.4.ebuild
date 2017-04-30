# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="C library for HTS data with bgzip, tabix and htsfile binaries"
HOMEPAGE="http://www.htslib.org/"
SRC_URI="mirror://sourceforge/samtools/${PV}/${P}.tar.bz2"

SLOT="2" # libhts.so.2
LICENSE="MIT"
KEYWORDS=""
IUSE="static-libs"

DEPEND="
	dev-libs/openssl:=
	app-arch/xz-utils
	app-arch/bzip2
	net-misc/curl"
RDEPEND="${DEPEND}"

src_install() {
	default
	if ! use static-libs; then
		find "${ED}" -type f -name "*.a" -delete || die
	fi
}

pkg_postinst(){
	einfo "You may want to install sci-libs/htslib-plugins"
}
