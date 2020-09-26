# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Library for rapid implementation of genome scale analyses"
HOMEPAGE="https://bitbucket.org/james_taylor/bx-python/wiki/Home"
SRC_URI="https://github.com/bxlab/bx-python/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"

# has file collision with sci-biology/RSeQC
