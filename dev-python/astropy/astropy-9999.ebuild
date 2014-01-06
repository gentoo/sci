# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1 git-r3

DESCRIPTION="Python routines and common tools needed for performing astronomy and astrophysics"
HOMEPAGE="http://astropy.org/ http://github.com/astropy/astropy"
SRC_URI=""
EGIT_REPO_URI="git://github.com/${PN}/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	sys-devel/flex
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		media-gfx/graphviz
	)
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	sed \
		-e '/use_system_pytest/ s/False/True/' \
		-i astropy/tests/helper.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc ; then
		pushd docs &> /dev/null
		PYTHONPATH="$(ls -d ${BUILD_DIR}/lib.*)" \
			sphinx-build -b html -d _build/doctrees . _build/html || die
		popd &> /dev/null
	fi
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_src_install_all
}
