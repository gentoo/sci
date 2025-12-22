# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi optfeature

DESCRIPTION="A Python package for gamma-ray astronomy"
HOMEPAGE="https://github.com/gammapy/gammapy"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

#TODO: Package all these pytest deps:
# 	pytest-doctestplus>=0.2.0
# 	pytest-remotedata>=0.3.1
# 	pytest-openfiles>=0.3.1
# 	pytest-astropy-header>=0.1.2
# 	pytest-arraydiff>=0.1
# 	pytest-filter-subpackage>=0.1
RESTRICT="test"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	>=dev-python/astropy-0.4[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/regions[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

# TODO: fix this
# There is a programmable error in your configuration file:
# KeyError: 'build_docs'
#distutils_enable_sphinx docs dev-python/sphinx-astropy
distutils_enable_tests pytest

pkg_postinst() {
	elog "To get additional features, a number of optional runtime"
	elog "dependencies may be installed:"
	elog ""
	optfeature "Plotting" dev-python/matplotlib
	optfeature "Plotting Astronomical Images" dev-python/aplpy
	optfeature "Read/write CVS files" dev-python/pandas
	optfeature "Image Processing" dev-python/scikit-image
	optfeature "Conversion helper functions" dev-python/rootpy

	# In science overlay:
	optfeature "Image photometry" dev-python/photutils
	optfeature "Image Utility Functions" dev-python/imageutils

	# Not packaged: Gammalib, ctools, sherpa, imfun, uncertainties, reproject
}
