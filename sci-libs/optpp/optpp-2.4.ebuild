# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils toolchain-funcs

DESCRIPTION="C++ library for non-linear optimization"
HOMEPAGE="https://software.sandia.gov/opt++/"
SRC_URI="${HOMEPAGE}/downloads/${P}.tar.gz"

LICENSE="LGPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="doc mpi static-libs"

RDEPEND="
	virtual/blas
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local myeconfargs=(
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		$(use_enable mpi)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use doc && dohtml -r docs/*
}
