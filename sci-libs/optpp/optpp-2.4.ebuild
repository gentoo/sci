# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="C++ library for non-linear optimization"
HOMEPAGE="https://software.sandia.gov/opt++/"
SRC_URI="https://software.sandia.gov/opt++/downloads/${P}.tar.gz"

LICENSE="LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc mpi static-libs"

RDEPEND="
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		$(use_enable mpi)
}

src_install() {
	default
	# avoid file collision with sci-libs/lapack
	rm "${ED}/usr/include/cblas.h"
	use doc && dodoc -r docs/*
}
