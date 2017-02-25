# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3 virtualx

DESCRIPTION="Python package for MEG and EEG data analysis"
HOMEPAGE="http://martinos.org/mne/mne-python.html"
EGIT_REPO_URI="https://github.com/mne-tools/mne-python.git"

LICENSE="BSD"
SLOT="0"
IUSE="test"
#IUSE="cuda test"
KEYWORDS=""

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-libs/scikits_learn[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	sci-biology/pysurfer[${PYTHON_USEDEP}]
	sci-visualization/mayavi
	dev-python/matplotlib[${PYTHON_USEDEP}]"

#	cuda? (
#		dev-python/pycuda[${PYTHON_USEDEP}]
#		dev-python/scikits-cuda[${PYTHON_USEDEP}]
#	)
#"

DEPEND="
	test? ( dev-python/nose ${RDEPEND} )
"

run_test() {
	PYTHONPATH=. MNE_SKIP_SAMPLE_DATASET_TESTS=1 nosetests -v mne
}

python_test() {
	distutils_install_for_testing
	esetup.py install --root="${T}/test-${EPYTHON}" --no-compile
	# Link to test data that won't be included in the final installation
	local TEST_DIR="${T}/test-${EPYTHON}/$(python_get_sitedir)"
	cd "${S}" || die
	find . -type d -name data -exec ln -s "${S}"/{} ${TEST_DIR}/{} \; || die
	cd ${TEST_DIR} || die
	VIRTUALX_COMMAND="run_test"
	virtualmake
}
