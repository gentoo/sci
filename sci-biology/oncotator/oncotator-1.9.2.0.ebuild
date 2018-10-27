# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 ) # no python3+, issue #364
inherit distutils-r1

DESCRIPTION="Annotate genetic variants in VCF"
HOMEPAGE="https://github.com/broadinstitute/oncotator"
SRC_URI="https://github.com/broadinstitute/oncotator/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="oncotator"
SLOT="0"
KEYWORDS="~amd64 ~x86" # breaks silently during install because of python syntax errors
IUSE=""

RESTRICT="fetch"

DEPEND="
	>=sci-biology/pysam-0.9.0
	>=dev-python/bcbio-gff-0.6.2
	>=dev-python/pyvcf-0.6.8
	>=dev-python/pandas-0.18.0
	>=sci-biology/biopython-1.66
	>=dev-python/numpy-1.11.0
	>=dev-python/cython-0.24
	>=dev-python/shove-0.6.6
	>=dev-python/sqlalchemy-1.0.12
	>=dev-python/nose-1.3.7
	>=dev-python/python-memcached-1.57
	>=dev-python/natsort-4.0.4
	>=dev-python/more-itertools-2.2
	>=dev-python/enum34-1.1.2
	dev-python/ngslib"
RDEPEND="${DEPEND}"
