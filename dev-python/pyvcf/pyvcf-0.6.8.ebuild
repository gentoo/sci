# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 )
inherit distutils-r1

DESCRIPTION="Work with VCF files in python"
HOMEPAGE="https://pypi.python.org/pypi/PyVCF"
SRC_URI="https://pypi.python.org/packages/20/b6/36bfb1760f6983788d916096193fc14c83cce512c7787c93380e09458c09/PyVCF-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="pyvcf"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-biology/pysam-0.8.0
	dev-python/cython"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/PyVCF-"${PV}"
