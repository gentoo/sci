# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit python autotools-utils

DESCRIPTION="C++ library for non-linear optimization"
HOMEPAGE="https://software.sandia.gov/opt++/"
SRC_URI="${HOMEPAGE}/downloads/${P}.tar.gz"

LICENSE="LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc mpi static-libs"

RDEPEND="virtual/blas
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	myeconfargs+=(
		--with-blas="$(pkg-config --libs blas)"
		$(use_enable mpi)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use doc && dohtml -r docs/*
}
