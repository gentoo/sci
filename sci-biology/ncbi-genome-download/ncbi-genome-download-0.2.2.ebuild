# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 python-r1

DESCRIPTION="Download genomes from the NCBI FTP servers"
HOMEPAGE="https://github.com/kblin/ncbi-genome-download"
SRC_URI="https://github.com/kblin/${PN}/archive/${PV}.tar.gz  -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
