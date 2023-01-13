# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..10} )

inherit distutils-r1

DESCRIPTION="Lightweight VCF to DB framework for disease and population genetics"
HOMEPAGE="https://github.com/arq5x/gemini
	http://gemini.readthedocs.org/en/latest"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/bottle[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/ipyparallel[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/numexpr[${PYTHON_USEDEP}]
	dev-python/openpyxl[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	sci-biology/bx-python[${PYTHON_USEDEP}]
	sci-libs/htslib
	sci-biology/pybedtools[${PYTHON_USEDEP}]
	sci-biology/pysam[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs

python_prepare_all() {
	# this has been renamed in newer versions of sphinx
	sed -i -e 's/sphinx.ext.pngmath/sphinx.ext.imgmath/g' docs/conf.py || die

	distutils-r1_python_prepare_all
}
