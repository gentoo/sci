# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_5 )

inherit git-r3 distutils-r1

DESCRIPTION="Python extension written in C for quick access to and creation of bigWig files"
HOMEPAGE="https://github.com/dpryan79/pyBigWig"
EGIT_REPO_URI="https://github.com/dpryan79/pyBigWig.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/libBigWig"
RDEPEND="${DEPEND}"
