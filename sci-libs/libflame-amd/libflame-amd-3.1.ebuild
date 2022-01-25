# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2
FORTRAN_NEED_OPENMP=1

DESCRIPTION="AMD optimized high-performance object-based library for DLA computations"
HOMEPAGE="https://developer.amd.com/amd-aocl/"
SRC_URI="https://github.com/amd/libflame/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libflame-${PV}"

KEYWORDS="~amd64"
LICENSE="BSD"
SLOT="0"

CPU_FLAGS=( sse3 )
IUSE_CPU_FLAGS_X86="${CPU_FLAGS[@]/#/cpu_flags_x86_}"
IUSE="scc supermatrix ${IUSE_CPU_FLAGS_X86[@]}"

DEPEND="virtual/cblas"
RDEPEND="${DEPEND}"
BDEPEND="dev-vcs/git"

src_configure() {
	local myconf=(
		--disable-optimizations
		--enable-multithreading=openmp
		--enable-verbose-make-output
		--enable-lapack2flame
		--enable-cblas-interfaces
		--enable-max-arg-list-hack
		--enable-dynamic-build
		--enable-vector-intrinsics=$(usex cpu_flags_x86_sse3 sse none)
		$(use_enable scc)
		$(use_enable supermatrix)
	)
	econf "${myconf[@]}"
}

src_install() {
	# -j1 because otherwise cannot create file that already exists
	DESTDIR="${ED}" emake -j1 install
	einstalldocs
}
