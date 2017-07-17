# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Work with BED, WIG, BigWIG, 2bit files in python"
HOMEPAGE="https://pypi.python.org/pypi/ngslib"
SRC_URI="https://pypi.python.org/packages/da/90/862bde7ea3e7a1f064872f51200b1558efa7c58df8131c39352f1c35fbdd/${P}.tar.gz"

LICENSE="GPL-3" # but Jim Kent's lib is 'for personal, academic and non-profit use only'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=sci-biology/pysam-0.8.2
	>=dev-python/numpy-1.4.1"
RDEPEND="${DEPEND}"

# contains bundled Jim Kent's library jkweb.a, probab;y do 'rm -rf ./external'
