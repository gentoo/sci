# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

MY_HASH="35a5f5205ba2aa54f1f0524564a6f1f8dafb237f"

DESCRIPTION="Neuroimaging tools for Python"
HOMEPAGE="https://nipy.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_HASH}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	"
DEPEND=""

S="${WORKDIR}/${PN}-${MY_HASH}"

python_prepare_all() {
	distutils-r1_python_prepare_all
	# bug #397605
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup" \
		|| append-ldflags -shared

	# nipy uses the horrible numpy.distutils automagic
}

#python_test() {
#	distutils-r1_install_for_testing
#	cp nipy/testing/*.nii.gz "${BUILD_DIR}/lib/nipy/testing/"
#	cp nipy/modalities/fmri/tests/*.{mat,npz,txt} "${BUILD_DIR}/lib/nipy/modalities/fmri/tests/"
#	cp nipy/algorithms/statistics/models/tests/test_data.bin "${BUILD_DIR}/lib/nipy/algorithms/statistics/models/tests"
#	cp nipy/labs/spatial_models/tests/some_blobs.nii "${BUILD_DIR}/lib/nipy/labs/spatial_models/tests/some_blobs.nii"
#	mkdir "${BUILD_DIR}/lib/nipy/algorithms/diagnostics/tests/data/"
#	cp nipy/algorithms/diagnostics/tests/data/tsdiff_results.mat "${BUILD_DIR}/lib/nipy/algorithms/diagnostics/tests/data/"
#	cd "${BUILD_DIR}" || die
#	echo "backend : agg" > matplotlibrc
#	nosetests || die
#}
