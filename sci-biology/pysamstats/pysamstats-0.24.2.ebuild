# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="Calculate statistics against genome positions from a SAM, BAM or CRAM file"
HOMEPAGE="https://github.com/alimanfoo/pysamstats
	https://pypi.python.org/pypi/pysamstats"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/cython
	>=sci-biology/pysam-0.8.4"
RDEPEND="${DEPEND}"
