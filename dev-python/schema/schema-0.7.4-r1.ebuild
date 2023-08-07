# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_11 pypy3 )
inherit distutils-r1 pypi

DESCRIPTION="Schema validation just got Pythonic"
HOMEPAGE="https://pypi.org/project/schema/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# Prevent schema from unconditionally requiring the last-rited contextlib2,
	# which schema actually conditionally requires only under EOL Python 2.x.
	sed -i -e '/\binstall_requires=/d' setup.py || die
}
