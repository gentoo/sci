# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 eutils multilib flag-o-matic

DESCRIPTION="Neuroimaging tools for Python"
HOMEPAGE="http://nipy.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/prov[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-1.2[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	"

python_prepare_all() {
	distutils-r1_python_prepare_all
	# bug #397605
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup" \
		|| append-ldflags -shared

	# nipy uses the horrible numpy.distutils automagic
}

python_test() {
	distutils-r1_install_for_testing
	cp nipy/testing/*.nii.gz "${BUILD_DIR}/lib/nipy/testing/"
	cp nipy/modalities/fmri/tests/*.{mat,npz,txt} "${BUILD_DIR}/lib/nipy/modalities/fmri/tests/"
	cp nipy/algorithms/statistics/models/tests/test_data.bin "${BUILD_DIR}/lib/nipy/algorithms/statistics/models/tests"
	cp nipy/labs/spatial_models/tests/some_blobs.nii "${BUILD_DIR}/lib/nipy/labs/spatial_models/tests/some_blobs.nii"
	mkdir "${BUILD_DIR}/lib/nipy/algorithms/diagnostics/tests/data/"
	cp nipy/algorithms/diagnostics/tests/data/tsdiff_results.mat "${BUILD_DIR}/lib/nipy/algorithms/diagnostics/tests/data/"
	cd "${BUILD_DIR}" || die
	echo "backend : agg" > matplotlibrc
	nosetests || die
}
