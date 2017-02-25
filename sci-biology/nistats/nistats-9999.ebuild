# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1 git-r3

DESCRIPTION="Neuroimaging tools for Python"
HOMEPAGE="http://nipy.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/nistats/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE=""
KEYWORDS=""

COMMONDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/patsy[${PYTHON_USEDEP}]
	"
DEPEND="${COMMONDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
RDEPEND="${COMMONDEPEND}
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	sci-biology/nilearn[${PYTHON_USEDEP}]
	"
