# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1 eutils git-r3 virtualx

DESCRIPTION="Image processing routines for SciPy"
HOMEPAGE="http://scikit-image.org/"
EGIT_REPO_URI="https://github.com/scikit-image/scikit-image.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc freeimage gtk pyamg qt4 test"

RDEPEND="
	>=dev-python/matplotlib-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/networkx-1.8[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/pillow-1.7.8[${PYTHON_USEDEP}]
	>=dev-python/six-1.3[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.9[sparse,${PYTHON_USEDEP}]
	freeimage? ( media-libs/freeimage )
	gtk? ( dev-python/pygtk[$(python_gen_usedep 'python2*')] )
	pyamg? ( dev-python/pyamg[$(python_gen_usedep 'python2*')] )
	qt4? ( dev-python/PyQt4[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	>=dev-python/cython-0.21[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		)"

DOCS=( CONTRIBUTORS.txt CONTRIBUTING.txt README.md DEPENDS.txt RELEASE.txt TASKS.txt )

python_test() {
	distutils_install_for_testing
	mkdir for_test && cd for_test || die
	echo "backend : Agg" > matplotlibrc || die
	echo "backend.qt4 : PyQt4" >> matplotlibrc || die
	VIRTUALX_COMMAND=nosetests
	MPLCONFIGDIR=. virtualmake --exe -v skimage || die
}

pkg_postinst() {
	optfeature "FITS io capability" dev-python/astropy
	#optfeature "io plugin providing a wide variety of formats, including specialized formats using in medical imaging." dev-python/simpleitk
	#optfeature "io plugin providing most standard formats" dev-python/imread
}
