# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Enthought Tool Suite: Explicitly typed attributes for Python"
HOMEPAGE="
	https://docs.enthought.com/traits/
	https://github.com/enthought/traits
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

distutils_enable_tests unittest
# ToDo: Fix doc building:
# AttributeError: 'NoDefaultSpecified' object has no attribute '__name__'
#distutils_enable_sphinx docs/source --no-autodoc

python_prepare_all() {
	sed -i -e "s/'-O3'//g" setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	cd "${BUILD_DIR}"/lib || die
	${EPYTHON} -m unittest discover || die
}
