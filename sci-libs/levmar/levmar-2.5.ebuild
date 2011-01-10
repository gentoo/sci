# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils

DESCRIPTION="A C/C++ implementation of the Levenberg-Marquardt non-linear regression"
HOMEPAGE="http://www.ics.forth.gr/~lourakis/levmar/"
SRC_URI="${HOMEPAGE}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="lapack"
RDEPEND="lapack? ( virtual/lapack )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	sed -e "s:-O3:${CFLAGS}:" -e 's:^LAPACKLIBS_PATH.*$:LAPACKLIBS=/usr/lib:' \
		-i Makefile
	if ! use lapack; then
		sed -e 's:^LAPACKFLAG:#LAPACKFLAG:' \
			-e 's:^LAPACKLIBS:#LAPACKLIBS:' \
			-i Makefile
	fi

}

src_install() {
	dolib liblevmar.a
	insinto /usr/include
	doins lm.h
	dodoc README.txt
}
