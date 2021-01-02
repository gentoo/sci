# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} ) # compile failure with py3.9

inherit distutils-r1

COMMIT="6e34cb4480ae7dbd8c5e44d221d8b27584890c83"

DESCRIPTION="Quantum chemistry package written in Python"
HOMEPAGE="https://github.com/rpmuller/pyquante2"
SRC_URI="https://github.com/rpmuller/pyquante2/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

# Fails to find self, even with --install
RESTRICT="test"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}2-${COMMIT}"

distutils_enable_sphinx docs --no-autodoc
distutils_enable_tests --install pytest

python_prepare_all() {
	# this has been renamed in newer versions of sphinx
	sed -i -e 's/sphinx.ext.pngmath/sphinx.ext.imgmath/g' docs/conf.py || die

	distutils-r1_python_prepare_all
}
