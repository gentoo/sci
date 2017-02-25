# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils db-use toolchain-funcs

DESCRIPTION="Molecular Dynamics Spectral Clustering Toolkit"
HOMEPAGE="https://github.com/douradopalmares/mdsctk"
SRC_URI="https://github.com/douradopalmares/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="examples R"

DEPEND="
	=sci-chemistry/gromacs-4.6*:=
	sci-libs/gsl
	sys-libs/db:=[cxx]
	virtual/blas
	virtual/lapack
	sci-libs/arpack
	R? ( dev-lang/R )
	"
RDEPEND="${DEPEND}"

src_configure() {
	echo 'include_directories(${DB_CXX_INCLUDE_PATH})' >> CMakeLists.txt
	local mycmakeargs=( -DDB_CXX_INCLUDE_PATH="$(db_includedir)" )
	cmake-utils_src_configure
}

src_install() {
	dodoc AUTHORS README.md
	use R && dobin clustering_nmi.r  clustering_pdf.r  density.r  entropy.r  kmeans.r  mdsctk.r  plot_pdf.r \
		probability.r
	insinto /usr/share/"${PN}"/examples
	use examples && doins -r examples
	cd "${BUILD_DIR}" || die
	dobin auto_decomp_sparse auto_decomp_sparse_nystrom bb_xtc_to_phipsi check_xtc decomp_sparse decomp_sparse_nystrom \
		knn_data knn_rms make_sysparse make_gesparse phipsi_to_sincos rms_test split_xtc
}
