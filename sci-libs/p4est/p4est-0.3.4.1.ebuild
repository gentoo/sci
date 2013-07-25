# Copyright 2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WANT_AUTOMAKE="1.11"

inherit autotools eutils

DESCRIPTION="Scalable Algorithms for Parallel Adaptive Mesh Refinement on Forests of Octrees"
HOMEPAGE="http://www.p4est.org/"
SRC_URI="http://burstedde.ins.uni-bonn.de/release/p4est-${PV}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="GPL-2+"
SLOT="0"

IUSE="mpi"

DEPEND="
	dev-lang/lua
	sys-apps/util-linux
	sys-libs/zlib
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi )"

RDEPEND="${DEPEND}
    virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-fix-install-locations.patch
    eautoreconf || die "eautoreconf failed"
}

src_configure() {
	blas=$(pkg-config --libs-only-l blas)
	lapack=$(pkg-config --libs-only-l lapack | cut -d' ' -f1)

	econf \
		--prefix="${EPREFIX}/usr" \
		--exec-prefix="${EPREFIX}/usr" \
		--enable-shared \
		--with-blas=${blas:2} \
		--with-lapack=${lapack:2} \
		$(use_enable mpi) \
		|| die "econf failed"
}
