# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Estimate best k-mer length to be used in novo assemblies"
HOMEPAGE="http://kmergenie.bx.psu.edu/"
SRC_URI="http://kmergenie.bx.psu.edu/${P}.tar.gz"

LICENSE="CeCILL-1.1"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-lang/R
"
RDEPEND="${DEPEND}"
