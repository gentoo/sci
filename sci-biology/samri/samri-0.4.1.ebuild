# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Small Animal Magnetic Resonance Imaging"
HOMEPAGE="https://github.com/IBT-FMI/SAMRI"
SRC_URI="https://github.com/IBT-FMI/SAMRI/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="labbookdb test"
KEYWORDS="~amd64"

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
	media-gfx/blender
	>=sci-biology/fsl-5.0.9
	sci-biology/bru2nii
	sci-biology/mouse-brain-atlases
	labbookdb? ( sci-libs/labbookdb[${PYTHON_USEDEP}] )
	sci-libs/nibabel[${PYTHON_USEDEP}]
	>=sci-libs/nipy-0.4.1[${PYTHON_USEDEP}]
	>=sci-libs/nipype-1.0.0[${PYTHON_USEDEP}]
	<=sci-libs/pybids-0.6.5[${PYTHON_USEDEP}]
	sci-libs/scikits_image[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-biology/ants
	sci-biology/afni
	sci-biology/nilearn[${PYTHON_USEDEP}]
"

S="${WORKDIR}/SAMRI-${PV}"

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e "s:/usr:@GENTOO_PORTAGE_EPREFIX@/usr:g" `grep -rlI \'/usr/ samri`
	sed -i -e "s:/usr:@GENTOO_PORTAGE_EPREFIX@/usr:g" `grep -rlI /usr/ test_scripts.sh`
	eprefixify $(grep -rl GENTOO_PORTAGE_EPREFIX samri/* test_scripts.sh)
}
