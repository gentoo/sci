# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

MY_PN="arrayfire"

DESCRIPTION="Python bindings for ArrayFire"
HOMEPAGE="http://www.arrayfire.com"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="
	>=sci-libs/arrayfire-3.2.0
	<sci-libs/arrayfire-3.3.0
	"
DEPEND="${RDEPEND}"
