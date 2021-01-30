# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fortran-2
FORTRAN_NEED_OPENMP=1

DESCRIPTION="AMD optimized high-performance object-based library for DLA computations"
HOMEPAGE="https://developer.amd.com/amd-aocl/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/amd/libflame"
else
	SRC_URI="https://github.com/amd/libflame/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/libflame-"${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

CPU_FLAGS=( sse3 )
IUSE_CPU_FLAGS_X86="${CPU_FLAGS[@]/#/cpu_flags_x86_}"
IUSE="scc static-libs supermatrix ${IUSE_CPU_FLAGS_X86[@]}"

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
		$(use_enable static-libs static-build)
		$(use_enable scc)
		$(use_enable supermatrix)
	)
	econf "${myconf[@]}"
}

src_compile() {
	default
}

src_install() {
	emake -j1 DESTDIR="${D}" install
}
