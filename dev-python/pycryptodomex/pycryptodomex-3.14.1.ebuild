# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3)
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Cryptographic library for Python"
HOMEPAGE="https://www.pycryptodome.org https://pypi.org/project/pycryptodomex/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/gmp:0=
	>=dev-libs/libtomcrypt-1.18.2-r1:=
"
BDEPEND="virtual/python-cffi[${PYTHON_USEDEP}]"
RDEPEND="
	${DEPEND}
	${BDEPEND}
"

PATCHES=(
	"${FILESDIR}/pycryptodome-3.10.1-system-libtomcrypt.patch"
)

distutils_enable_tests setup.py

python_prepare_all() {
	# make sure we're unbundling it correctly
	rm -r src/libtom || die

	distutils-r1_python_prepare_all
}
