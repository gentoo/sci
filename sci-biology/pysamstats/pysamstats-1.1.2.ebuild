# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="Calculate stats against genome positions from SAM/BAM/CRAM file"
HOMEPAGE="https://github.com/alimanfoo/pysamstats
	https://pypi.python.org/pypi/pysamstats"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="" # needs working pysam, see bug #645060
IUSE=""

DEPEND="
	dev-python/cython
	dev-python/numpy
	dev-python/pytables
	>=sci-biology/pysam-0.15.1"
RDEPEND="${DEPEND}"
