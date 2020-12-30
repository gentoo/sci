# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="In-memory K-mer counting in DNA/RNA/protein sequences"
HOMEPAGE="https://github.com/dib-lab/khmer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# ToDo: Fix this:
# ModuleNotFoundError: No module named 'khmer._khmer'
# even happens with --install option for enable_tests
RESTRICT="test"

RDEPEND="
	sci-biology/screed[${PYTHON_USEDEP}]
	dev-python/bz2file[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# do not depend on pytest-runner
	sed -i "/pytest-runner/d" setup.py || die
	distutils-r1_python_prepare_all
}
