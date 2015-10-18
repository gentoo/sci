# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils toolchain-funcs

MYP="Healpix_3.11"

DESCRIPTION="Hierarchical Equal Area isoLatitude Pixelization of a sphere - C++"
HOMEPAGE="http://healpix.sourceforge.net/"
SRC_URI="mirror://sourceforge/healpix/${MYP}/autotools_packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="openmp static-libs"

RDEPEND="
	>=sci-libs/cfitsio-3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	if use openmp && [[ $(tc-getCXX)$ == *g++* ]]; then
		if ! tc-has-openmp; then
			ewarn "You are using a g++ without OpenMP capabilities"
			die "Need an OpenMP capable compiler"
		fi
	fi
}

src_prepare() {
	# why was static-libtool-libs forced?
	# it screws up as-neeeded
	use static-libs || sed -i -e '/-static-libtool-libs/d' Makefile.am
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable openmp)
	)
	autotools-utils_src_configure
}
