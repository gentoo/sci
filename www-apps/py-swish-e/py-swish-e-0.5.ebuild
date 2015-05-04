# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Python API for swish-e"
HOMEPAGE="http://py-swish-e.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P/py-/}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=www-apps/swish-e-2.4"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/SwishE-${PV}
