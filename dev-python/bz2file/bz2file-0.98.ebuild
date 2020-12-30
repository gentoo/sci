# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Read and write bzip2-compressed files"
HOMEPAGE="https://github.com/nvawda/bz2file"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${P}-always-threading.patch )

python_test() {
	distutils_install_for_testing
	${EPYTHON} test_bz2file.py || die "tests failed for ${EPYTHON}"
}
