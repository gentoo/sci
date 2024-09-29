# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Adapter trimming and other preprocessing of high-throughput sequencing reads"
HOMEPAGE="https://github.com/marcelm/cutadapt/"
SRC_URI="$(pypi_sdist_url "${PN^}" "${PV}")"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"
DEPEND="
	>=dev-python/xopen-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/dnaio-1.2.0[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	test? ( dev-python/pytest )
"
distutils_enable_tests pytest
