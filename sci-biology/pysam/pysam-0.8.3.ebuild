# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python interface for the SAM/BAM sequence alignment and mapping format"
HOMEPAGE="https://github.com/pysam-developers/pysam http://pypi.python.org/pypi/pysam"
SRC_URI="https://github.com/pysam-developers/${PN}/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=sci-biology/samtools-1.2[${PYTHON_USEDEP}]
	>=sci-libs/htslib-1.2.1"

PATCHES=( "${FILESDIR}/${P}-cython-0.23.patch" )

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}
