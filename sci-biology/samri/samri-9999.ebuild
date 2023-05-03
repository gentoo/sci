# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 prefix

DESCRIPTION="Small Animal Magnetic Resonance Imaging"
HOMEPAGE="https://github.com/IBT-FMI/SAMRI"
if [ "$PV" == "9999" ]; then
		inherit git-r3
		EGIT_REPO_URI="https://github.com/IBT-FMI/SAMRI.git"
else
		SRC_URI="https://github.com/IBT-FMI/SAMRI/archive/${PV}.tar.gz -> ${P}.tar.gz"
		KEYWORDS="~amd64"
		S="${WORKDIR}/SAMRI-${PV}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+atlases labbookdb"
REQUIRED_USE="test? ( atlases )"

DEPEND="
	test? (
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
	atlases? ( sci-biology/mouse-brain-templates )
	labbookdb? ( sci-libs/labbookdb[${PYTHON_USEDEP}] )
	sci-libs/nibabel[${PYTHON_USEDEP}]
	>=sci-libs/nipy-0.4.1[${PYTHON_USEDEP}]
	>=sci-libs/nipype-1.0.0[${PYTHON_USEDEP}]
	<sci-libs/pybids-0.10.2[${PYTHON_USEDEP}]
	sci-libs/scikit-image[${PYTHON_USEDEP}]
	sci-biology/ants
	sci-biology/afni
	sci-biology/nilearn[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx doc/source dev-python/sphinxcontrib-napoleon

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e "s:/usr:@GENTOO_PORTAGE_EPREFIX@/usr:g" `grep -rlI \'/usr/ samri` || die
	sed -i -e "s:/usr:@GENTOO_PORTAGE_EPREFIX@/usr:g" `grep -rlI /usr/ test_scripts.sh` || die
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
	epytest -k "not longtime"
}
