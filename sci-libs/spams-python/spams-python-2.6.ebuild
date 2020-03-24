# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Optimization toolbox for solving various sparse estimation problems"
HOMEPAGE="http://spams-devel.gforge.inria.fr/index.html"
SRC_URI="https://github.com/samuelstjean/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	virtual/blas
	virtual/lapack
	"
RDEPEND="${DEPEND}
	sci-libs/scipy[${PYTHON_USEDEP}]
	"

pc_libdir() {
	$(tc-getPKG_CONFIG) --libs-only-L $@ | \
		sed -e 's/^-L//' -e 's/[ ]*-L/:/g' -e 's/[ ]*$//' -e 's|^,||'
}

pc_libs() {
	$(tc-getPKG_CONFIG) --libs-only-l $@ | \
		sed -e 's/[ ]-l*\(pthread\|m\)\([ ]\|$\)//g' \
		-e 's/^-l//' -e 's/[ ]*-l/,/g' -e 's/[ ]*$//' \
		| tr ',' '\n' | sort -u | tr '\n' ',' | sed -e 's|,$||'
}
pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

python_prepare_all() {
	local libdir="${EPREFIX}"/usr/$(get_libdir)
	MY_LAPACK=$(pc_libs lapack)
	MY_BLAS=$(pc_libs blas)
	MY_LIBDIRS="$(pc_libdir blas lapack)'${libdir}'"
	sed -i -e "s/'blas', 'lapack'/'${MY_BLAS}', '${MY_LAPACK}'/g" setup.py || die
	sed -i -e "s|libdirs = \[\]|libdirs = [${MY_LIBDIRS}]|g" setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	${EPYTHON} test_spams.py
}
