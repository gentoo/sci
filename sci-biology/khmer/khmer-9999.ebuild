# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils git-r3

DESCRIPTION="In-memory K-mer counting in DNA/RNA/protein sequences"
HOMEPAGE="https://github.com/ged-lab/khmer"
#SRC_URI=""
EGIT_REPO_URI="git://github.com/ged-lab/khmer"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
