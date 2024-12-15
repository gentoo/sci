# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=scikit-build-core

inherit distutils-r1 pypi

DESCRIPTION="LightGBM Python Package"
HOMEPAGE="https://github.com/microsoft/LightGBM"
SRC_URI="$(pypi_sdist_url "${PN^}" "${PV}")"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/scikit-learn[${PYTHON_USEDEP}]
	sci-libs/lightgbm"
distutils_enable_tests pytest

PATCHES=( "${FILESDIR}/${PN}-4.5.0-loadlib.patch" )

python_compile() {
	SKBUILD_WHEEL_CMAKE=false distutils-r1_python_compile
}
