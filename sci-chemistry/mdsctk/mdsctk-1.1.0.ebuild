# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils db-use toolchain-funcs

DESCRIPTION="Molecular Dynamics Spectral Clustering Toolkit"
HOMEPAGE="http://cnls.lanl.gov/~jphillips/?page_id=45"
SRC_URI="http://cnls.lanl.gov/~jphillips/wp-content/uploads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="examples R"

DEPEND="
	sci-chemistry/gromacs:=
	sci-libs/gsl
	sys-libs/db[cxx]
	virtual/blas
	virtual/lapack
	sci-libs/arpack
	R? ( dev-lang/R )
	"
RDEPEND="${DEPEND}"

src_configure() {
	# all this hacking is due to the fact that check_include_file_cxx
	# has no support for CMAKE_{SYSTEM_,}_INCLUDE_PATH, so we fake it
	# using CMAKE_REQUIRED_INCLUDES and a symlink
	local mycmakeargs=( -DCMAKE_REQUIRED_INCLUDES="$(db_includedir)" )
	cmake-utils_src_configure
	ln -s "$(db_includedir)"/db_cxx.h "${BUILD_DIR}" || die
}

src_install() {
	dodoc AUTHORS README
	use R && dobin clustering_histogram.r  clustering_nmi.r  kmeans.r plot_histogram.r
	insinto /usr/share/"${PN}"/examples
	use examples && doins -r examples
	cd "${BUILD_DIR}" || die
	dobin auto_decomp_sparse auto_decomp_sparse_nystrom bb_xtc_to_phipsi check_xtc decomp_sparse decomp_sparse_nystrom \
		knn_data knn_rms make_sysparse make_gesparse phipsi_to_sincos rms_test split_xtc
}
