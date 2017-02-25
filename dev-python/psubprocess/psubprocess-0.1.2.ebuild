# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Execute tasks in parallel"
HOMEPAGE="http://bioinf.comav.upv.es/psubprocess"
SRC_URI="http://bioinf.comav.upv.es/_downloads/"${P}".tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
