# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Efficient pythonic random access to fasta subsequences"
HOMEPAGE="https://pypi.python.org/pypi/pyfaidx https://github.com/mdshw5/pyfaidx"
SRC_URI="https://github.com/mdshw5/pyfaidx/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REPEND="dev-python/six[${PYTHON_USEDEP}]"

#distutils_enable_tests nose
