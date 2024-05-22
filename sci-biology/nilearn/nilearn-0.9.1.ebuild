# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Fast and easy statistical learning on NeuroImaging data"
HOMEPAGE="http://nilearn.github.io/"
SRC_URI="https://github.com/nilearn/nilearn/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/joblib-0.15[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.18[${PYTHON_USEDEP}]
	>=dev-python/pandas-1[${PYTHON_USEDEP}]
	>=dev-python/requests-2[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.5[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-3[${PYTHON_USEDEP}]
	>=dev-python/scikit-learn-0.22[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${P}-tests.patch" )

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	"examples/05_glm_second_level/plot_second_level_association_test.py"
	"examples/05_glm_second_level/plot_second_level_one_sample_test.py"
	"examples/05_glm_second_level/plot_second_level_two_sample_test.py"
)
# Reported upstream:
# https://github.com/nilearn/nilearn/issues/3232
EPYTEST_DESELECT=(
	"nilearn/decoding/tests/test_decoder.py::test_decoder_dummy_classifier"
	"nilearn/interfaces/fmriprep/tests/test_load_confounds.py::test_nilearn_standardize[False-True-zscore]"
	"nilearn/interfaces/fmriprep/tests/test_load_confounds.py::test_nilearn_standardize[False-True-psc]"
	"nilearn/interfaces/fmriprep/tests/test_load_confounds.py::test_nilearn_standardize[True-True-zscore]"
	"nilearn/interfaces/fmriprep/tests/test_load_confounds.py::test_nilearn_standardize[True-True-psc]"
)

python_test() {
	echo "backend: Agg" > matplotlibrc
	MPLCONFIGDIR=. epytest
}
