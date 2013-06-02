# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit db-use toolchain-funcs

DESCRIPTION="Molecular Dynamics Spectral Clustering Toolkit"
HOMEPAGE="http://cnls.lanl.gov/~jphillips/?page_id=45"
SRC_URI="http://cnls.lanl.gov/~jphillips/wp-content/uploads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples R"

DEPEND="
	sci-chemistry/gromacs
	sci-libs/gsl
	sys-libs/db[cxx]
	virtual/blas
	virtual/lapack
	R? ( dev-lang/R )
	"
RDEPEND="${DEPEND}"

src_compile() {
	local libdb=$(db_libname)
	emake CPP=$(tc-getCXX) \
		CFLAGS="${CXXFLAGS} $($(tc-getPKG_CONFIG) --cflags libgmx) \
			$($(tc-getPKG_CONFIG) --cflags gsl) \
			$($(tc-getPKG_CONFIG) --cflags lapack) \
			$($(tc-getPKG_CONFIG) --cflags blas) \
			-I$(db_includedir)" \
		LIBS="$($(tc-getPKG_CONFIG) --libs libgmx) -lgmxana \
			$($(tc-getPKG_CONFIG) --libs gsl) \
			$($(tc-getPKG_CONFIG) --libs lapack) \
			$($(tc-getPKG_CONFIG) --libs blas) \
			-l${libdb/db/db_cxx} ${LDFLAGS}" \
		OPTIONS=""
}

src_install() {
	dodoc AUTHORS README
	dobin auto_decomp_sparse bb_xtc_to_phipsi check_xtc decomp_sparse knn_data \
		knn_rms knn_rms_sparse make_sparse phipsi_to_sincos rms_test
	use R && dobin clustering_histogram.r  clustering_nmi.r  kmeans.r plot_histogram.r
	insinto /usr/share/"${PN}"/examples
	use examples && doins -r examples
}
