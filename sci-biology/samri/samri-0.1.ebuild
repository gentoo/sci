# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Small Animal Magnetic Resonance Imaging"
HOMEPAGE="https://github.com/IBT-FMI/SAMRI"
SRC_URI="https://github.com/IBT-FMI/SAMRI/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="atlases labbookdb test"
KEYWORDS="~amd64 ~x86"

# Numpy dependency to circumvent scikits_learn dependency bug:
# https://bugs.gentoo.org/653052
DEPEND="test? ( sci-biology/samri_bindata )"
RDEPEND="
	dev-python/argh[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-2.0.2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.13.3[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/seaborn[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/statsmodels[${PYTHON_USEDEP}]
	>=sci-biology/fsl-5.0.9
	sci-biology/bru2nii
	atlases? ( sci-biology/mouse-brain-atlases )
	labbookdb? ( sci-libs/labbookdb[${PYTHON_USEDEP}] )
	sci-libs/nibabel[${PYTHON_USEDEP}]
	>=sci-libs/nipy-0.4.1[${PYTHON_USEDEP}]
	>=sci-libs/nipype-0.14.0_pre20170830[${PYTHON_USEDEP}]
	sci-libs/pybids[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-biology/ants
	sci-biology/afni
	sci-biology/nilearn[${PYTHON_USEDEP}]
	"

S="${WORKDIR}/SAMRI-${PV}"

python_test() {
	distutils_install_for_testing
	export MPLBACKEND="agg"
	export PATH=${TEST_DIR}/scripts:$PATH
	export PYTHONIOENCODING=utf-8
	pytest || die
	for i in samri/examples/*.py; do
		echo "Executing ${EPYTHON} ${i}"
		${EPYTHON} "$i" || die "Example Python script $i failed with ${EPYTHON}"
	done
	./test_scripts.sh || die "Test scripts failed."
}
