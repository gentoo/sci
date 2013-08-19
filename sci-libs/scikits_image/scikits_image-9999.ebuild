# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/scikits_image/scikits_image-0.8.2.ebuild,v 1.3 2013/06/18 04:33:25 patrick Exp $

EAPI=5

# pyamg missing py3 support
#PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1 git-2

MYPN="${PN/scikits_/scikit-}"

DESCRIPTION="Image processing routines for SciPy"
HOMEPAGE="http://scikit-image.org/"
EGIT_REPO_URI="https://github.com/scikit-image/scikit-image.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc freeimage gtk qt4 test"

RDEPEND="
	sci-libs/scipy[sparse,${PYTHON_USEDEP}]
	freeimage? ( media-libs/freeimage )
	gtk? ( dev-python/pygtk[$(python_gen_usedep 'python2*')] )
	qt4? ( dev-python/PyQt4[${PYTHON_USEDEP}] )"
DEPEND="
	>=dev-python/cython-0.15[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.6[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pyamg[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MYPN}-${PV}"

DOCS=( CONTRIBUTORS.txt DEPENDS.txt RELEASE.txt TASKS.txt )

python_test() {
	esetup.py \
		install --root="${T}/test-${EPYTHON}" \
		--no-compile || die "install test failed"
	#distutils_install_for_testing
	cd "${T}/test-${EPYTHON}/$(python_get_sitedir)" || die
	echo "backend: Agg" > matplotlibrc
	MPLCONFIGDIR=. PYTHONPATH=. nosetests-"${EPYTHON}" || die
}
