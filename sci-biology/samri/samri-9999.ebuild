# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit distutils-r1 git-r3 prefix

DESCRIPTION="Small Animal Magnetic Resonance Imaging"
HOMEPAGE="https://github.com/IBT-FMI/SAMRI"
SRC_URI=""
EGIT_REPO_URI="https://github.com/IBT-FMI/SAMRI"

LICENSE="GPL-3"
SLOT="0"
IUSE="+atlases labbookdb test"
KEYWORDS=""

# Numpy dependency to circumvent scikits_learn dependency bug:
# https://bugs.gentoo.org/653052
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
	dev-python/seaborn[${PYTHON_USEDEP}]
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

REQUIRED_USE="test? ( atlases )"

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e "s:/usr:@GENTOO_PORTAGE_EPREFIX@/usr:g" `grep -rlI \'/usr/ *`
	sed -i -e "s:/usr:@GENTOO_PORTAGE_EPREFIX@/usr:g" `grep -rlI \"/usr/ *`
	sed -i -e "s:/usr:@GENTOO_PORTAGE_EPREFIX@/usr:g" `grep -rlI /usr/ test_scripts.sh`
	eprefixify $(grep -rl GENTOO_PORTAGE_EPREFIX samri/* test_scripts.sh)
}

python_test() {
	distutils_install_for_testing
	export MPLBACKEND="agg"
	export PATH=${TEST_DIR}/scripts:$PATH
	export PYTHONIOENCODING=utf-8
	./test_scripts.sh || die "Test scripts failed."
	sed -i \
		-e '1s/^/import pytest \n/' \
		-e "/def test_bru2bids():/i@pytest.mark.skip('Skipped by Portage, as this was already tested in test_scripts.sh')" \
		samri/pipelines/tests/test_reposit.py || die
	cd "${BUILD_DIR}" || die
	sed -i -e "s:'/tmp/:'$T/:g" `grep -rl "'/tmp/"`
	pytest -vv || die
	sed -i -e "s:'$T/:'/tmp/:g" `grep -rl "'$T/"`
}
