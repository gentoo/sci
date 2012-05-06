# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://github.com/${PN}/${PN}.git"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5 2.7-pypy-* *-jython"
DISTUTILS_SRC_TEST=setup.py

inherit distutils git-2

DESCRIPTION="Python routines and common tools needed for performing astronomy and astrophysics"
HOMEPAGE="http://astropy.org/ http://github.com/astropy/astropy"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

RDEPEND="dev-python/numpy"
DEPEND="${RDEPEND}
	dev-python/setuptools
	sys-devel/flex
	doc? (
		dev-python/sphinx
		media-gfx/graphviz
	)
	test? ( dev-python/pytest )"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

src_prepare() {
	sed -e '/use_system_pytest/ s/False/True/' \
		-i astropy/tests/helper.py || die
	distutils_src_prepare
}

src_compile() {
	distutils_src_compile
	if use doc ; then
		pushd docs &> /dev/null
		PYTHONPATH="$(ls -d ../build-$(PYTHON --ABI -f)/lib.*)" \
			sphinx-build -b html -d _build/doctrees   . _build/html || die
		popd &> /dev/null
	fi
}

src_install() {
	distutils_src_install
	use doc && { dohtml -r docs/_build/html/* ; }
}
