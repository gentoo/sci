# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Python package for MEG and EEG data analysis"
HOMEPAGE="http://martinos.org/mne/mne-python.html"
SRC_URI="https://github.com/mne-tools/mne-python/archive/v${PV}.zip"

LICENSE="BSD"
SLOT="0"
IUSE="test"
#IUSE="cuda test"
KEYWORDS="~x86 ~amd64"

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

src_test() {
	emake test-code
}
