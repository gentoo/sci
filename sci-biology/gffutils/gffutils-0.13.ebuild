# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="GFF and GTF file manipulation and interconversion"
HOMEPAGE="https://gffutils.readthedocs.io/en/latest/"
SRC_URI="https://github.com/daler/gffutils/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/argh[${PYTHON_USEDEP}]
	dev-python/argcomplete[${PYTHON_USEDEP}]
	dev-python/pyfaidx[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

# https://github.com/daler/gffutils/issues/233 + cli not installed yet
EPYTEST_DESELECT=(
	gffutils/test/test_biopython_integration.py::test_roundtrip
	gffutils/test/test_cli.py::test_issue_224
)

distutils_enable_tests pytest
