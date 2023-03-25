# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="GFF and GTF file manipulation and interconversion"
HOMEPAGE="https://gffutils.readthedocs.io/en/latest/"
SRC_URI="https://github.com/daler/gffutils/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# Nose tests no longer supported
RESTRICT="test"

RDEPEND="
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/argh[${PYTHON_USEDEP}]
	dev-python/argcomplete[${PYTHON_USEDEP}]
	sci-biology/biopython[${PYTHON_USEDEP}]
	sci-biology/pybedtools[${PYTHON_USEDEP}]
	sci-biology/pyfaidx[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_prepare_all() {
	if use test; then
		sed -i -e "s:/tmp/gffutils-test:${T}:g" gffutils/test/test.py || die
	fi
	distutils-r1_python_prepare_all
}

distutils_enable_tests nose
python_test() {
	distutils_install_for_testing
	nosetests -v -x --with-doctest -a '!slow' || die
}
