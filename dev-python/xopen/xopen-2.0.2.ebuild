# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Open compressed files transparently"
HOMEPAGE="https://github.com/marcelm/xopen/"
SRC_URI="$(pypi_sdist_url "${PN^}" "${PV}")"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"
DEPEND="
	dev-python/isal[${PYTHON_USEDEP}]
	sys-libs/zlib-ng
"
RDEPEND="
	${DEPEND}
	test? ( dev-python/pytest )
"
distutils_enable_tests pytest
