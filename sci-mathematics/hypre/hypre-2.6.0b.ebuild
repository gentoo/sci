# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils fortran-2

DESCRIPTION="Parallel High Performance Preconditioners library for scalable
solution of linear systems"
HOMEPAGE="http://www.llnl.gov/casc/hypre/"
SRC_URI="https://computation.llnl.gov/casc/hypre/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug fortran static-libs"

RDEPEND="
	virtual/mpi
	sys-devel/gcc[fortran?]
	virtual/blas
	virtual/lapack
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/src"

src_prepare() {
	epatch "${FILESDIR}/makefile-mpicxx.patch"
}

src_configure() {
	local myconf
	use static-libs \
		&& myconf[0]="--disable-shared" \
		|| myconf[0]="--enable-shared"
	myconf[1]="$(use_enable debug)"
	myconf[2]="$(use_enable fortran)"
	myconf[3]="--disable-python"
	myconf[4]="--disable-java"
	myconf[5]="--with-MPI"
	myconf[6]="--with-blas"
	myconf[7]="--with-lapack"

	econf "${myconf[@]}" || die "configure failed"
}

src_install() {
	if use static-libs; then
		dolib.a  lib/libHYPRE*.a
	else
		dolib.so lib/libHYPRE*.so
	fi
	insinto /usr/include/${PN}
	doins -r hypre/include/*
}
