# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python package for MEG and EEG data analysis"
HOMEPAGE="http://martinos.org/mne/mne-python.html"
SRC_URI="https://github.com/mne-tools/mne-python/archive/v${PV}.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
IUSE="test"
KEYWORDS="~x86 ~amd64"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-libs/scikits_learn[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	"

DEPEND="
	test? ( dev-python/nose ${RDEPEND} )
	"

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	nosetests -v mne || die
}
