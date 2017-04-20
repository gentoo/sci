# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 )
inherit distutils-r1

DESCRIPTION="Read and write Generic Feature Format (GFF) with Biopython"
HOMEPAGE="https://pypi.python.org/pypi/bcbio-gff"
SRC_URI="https://pypi.python.org/packages/94/df/e2d75cc688ac6eb53f5fb4e2cffd240596bbcd5be28bab8d4f6404a6f86c/bcbio-gff-0.6.4.tar.gz"

LICENSE="HPND" # same as biopython
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
