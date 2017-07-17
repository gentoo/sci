# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Remove adapter sequences from high-throughput sequencing data"
HOMEPAGE="https://github.com/marcelm/cutadapt"
EGIT_REPO_URI="https://github.com/marcelm/cutadapt"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-python/xopen-0.1.1[${PYTHON_USEDEP}]"
