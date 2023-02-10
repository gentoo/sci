# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Core functionality for performing astrophysics with Python"
HOMEPAGE="https://www.astropy.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#TODO: Package all these pytest deps:
# 	pytest-remotedata>=0.3.1
# 	pytest-openfiles>=0.3.1
# 	pytest-astropy-header>=0.1.2
# 	pytest-arraydiff>=0.1
# 	pytest-filter-subpackage>=0.1
RESTRICT="test"

RDEPEND="
	dev-libs/expat:0=
	>=dev-python/numpy-1.18[${PYTHON_USEDEP}]
	>=dev-python/pyerfa-2.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.13[${PYTHON_USEDEP}]
	>=dev-python/packaging-19.0[${PYTHON_USEDEP}]
	sci-astronomy/wcslib:0=
	>=sci-libs/cfitsio-3.350:0=
	sys-libs/zlib:0=
"
BDEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/extension-helpers[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-libs/libxml2
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/objgraph[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
# TODO: Fix this
# NameError: name 'disabled_intersphinx_mapping' is not defined
#distutils_enable_sphinx docs \
# 	dev-python/matplotlib \
# 	dev-python/graphviz \
# 	dev-python/sphinx-astropy \
# 	dev-python/pyyaml \
# 	dev-python/scipy
