# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 )

inherit distutils-r1

DESCRIPTION="Python library for accessing 2bit files"
HOMEPAGE="https://github.com/dpryan79/py2bit"
SRC_URI="https://github.com/dpryan79/py2bit/archive/0.2.1.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-libs/lib2bit"
RDEPEND="${DEPEND}"
