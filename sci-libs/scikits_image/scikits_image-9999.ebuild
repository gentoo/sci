# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/scikits_image/scikits_image-0.8.2.ebuild,v 1.3 2013/06/18 04:33:25 patrick Exp $

EAPI=5

# pyamg missing py3 support
#PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1 git-r3

DESCRIPTION="Image processing routines for SciPy"
HOMEPAGE="http://scikit-image.org/"
EGIT_REPO_URI="https://github.com/scikit-image/scikit-image.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc freeimage gtk qt4 test"

RDEPEND="
	sci-libs/scipy[sparse,${PYTHON_USEDEP}]
	freeimage? ( media-libs/freeimage )
	gtk? ( dev-python/pygtk[$(python_gen_usedep 'python2*')] )
	qt4? ( dev-python/PyQt4[${PYTHON_USEDEP}] )"
DEPEND="
	>=dev-python/cython-0.17[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pyamg[${PYTHON_USEDEP}]
		sci-libs/scipy[sparse,${PYTHON_USEDEP}] )"

DOCS=( CONTRIBUTORS.txt CONTRIBUTING.txt README.md DEPENDS.txt RELEASE.txt TASKS.txt )

python_test() {
	# distutils_install_for_testing not working here
	esetup.py \
		install --root="${T}/test-${EPYTHON}" \
		--no-compile
	cd "${T}/test-${EPYTHON}/$(python_get_sitedir)" || die
	echo "backend: Agg" > matplotlibrc || die
	MPLCONFIGDIR=. nosetests -v skimage || die
}
