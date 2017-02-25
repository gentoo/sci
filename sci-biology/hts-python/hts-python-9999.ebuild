# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Pythonic wrapper for htslib C-API using python cffi (unlike pysam)"
HOMEPAGE="https://github.com/brentp/hts-python"
EGIT_REPO_URI="https://github.com/brentp/hts-python.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/cffi[${PYTHON_USEDEP}]"
