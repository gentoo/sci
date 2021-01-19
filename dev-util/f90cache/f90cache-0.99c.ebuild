# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2 multilib toolchain-funcs

DESCRIPTION="Compiler cache for fortran"
HOMEPAGE="https://perso.univ-rennes1.fr/edouard.canot//f90cache/"
SRC_URI="https://perso.univ-rennes1.fr/edouard.canot//f90cache/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-util/ccache"

src_prepare() {
	default
	sed -i -e '/OBJS/s/CFLAGS/LDFLAGS/' -e '/strip/d' Makefile.in || die
}

src_install() {
	default

	#we depend on ccache, put links in there so that portage find it
	#TODO improve this
	dosym ../../../bin/f90cache "${ROOT}/usr/$(get_libdir)/ccache/bin/gfortran"
}

pkg_postinst() {
	elog "Please add F90CACHE_DIR=\"${ROOT}/var/tmp/f90cache\""
	elog "to your make.conf otherwise f90cache files end up in"
	elog "home of the user executing portage"
}
