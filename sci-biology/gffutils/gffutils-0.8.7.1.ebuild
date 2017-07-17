# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="GFF and GTF file manipulation and interconversion"
HOMEPAGE="https://pythonhosted.org/gffutils/"
SRC_URI="https://github.com/daler/gffutils/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sci-biology/pyfaidx[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
