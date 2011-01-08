# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Python API for swish-e"
HOMEPAGE="http://py-swish-e.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P/py-/}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=www-apps/swish-e-2.4"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/SwishE-${PV}
