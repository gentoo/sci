# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 mercurial

DESCRIPTION="Library for rapid implementation of genome scale analyses"
HOMEPAGE="https://bitbucket.org/james_taylor/bx-python/wiki/Home"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/james_taylor/bx-python"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"

# has file collision with sci-biology/RSeQC
