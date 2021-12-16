# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} )

inherit distutils-r1 prefix git-r3

DESCRIPTION="Small Animal Magnetic Resonance Imaging"
HOMEPAGE="https://github.com/IBT-FMI/SAMRI"
SRC_URI=""
EGIT_REPO_URI="https://github.com/IBT-FMI/SAMRI"

LICENSE="GPL-3"
SLOT="0"
IUSE="+atlases labbookdb test"
KEYWORDS=""
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		sci-biology/samri_bidsdata
		sci-biology/samri_bindata
		)
	"
RDEPEND="
	dev-python/argh[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-2.0.2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.13.3[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/seaborn[${PYTHON_USEDEP}]
	dev-python/statsmodels[${PYTHON_USEDEP}]
	>=media-gfx/blender-2.83.4
	>=sci-biology/fsl-5.0.9
	sci-biology/bru2nii
	atlases? ( sci-biology/mouse-brain-atlases )
	labbookdb? ( sci-libs/labbookdb[${PYTHON_USEDEP}] )
	sci-libs/nibabel[${PYTHON_USEDEP}]
	>=sci-libs/nipy-0.4.1[${PYTHON_USEDEP}]
	>=sci-libs/nipype-1.0.0[${PYTHON_USEDEP}]
	sci-libs/pybids[${PYTHON_USEDEP}]
	sci-libs/scikit-image[${PYTHON_USEDEP}]
	sci-biology/ants
	sci-biology/afni
	sci-biology/nilearn[${PYTHON_USEDEP}]
"

REQUIRED_USE="test? ( atlases )"

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e "s:/usr:@GENTOO_PORTAGE_EPREFIX@/usr:g" `grep -rlI \'/usr/ samri`
	sed -i -e "s:/usr:@GENTOO_PORTAGE_EPREFIX@/usr:g" `grep -rlI /usr/ test_scripts.sh`
	eprefixify $(grep -rl GENTOO_PORTAGE_EPREFIX samri/* test_scripts.sh)
}

python_test() {
	distutils_install_for_testing
	export MPLBACKEND="agg"
	export PATH=${TEST_DIR}/scripts:$PATH
	export PYTHONIOENCODING=utf-8
	./test_scripts.sh || die "Test scripts failed."
	sed -i -e \
		"/def test_bru2bids():/i@pytest.mark.skip('Removed in full test suite, as this is already tested in `test_scripts.sh`')" \
		samri/pipelines/tests/test_repos.py || die
	pytest -vv -k "not longtime" || die
}
