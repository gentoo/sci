# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Python bindings for ArrayFire"
HOMEPAGE="http://www.arrayfire.com"
SRC_URI="https://github.com/arrayfire/arrayfire-python/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=sci-libs/arrayfire-3.3.2
	<sci-libs/arrayfire-3.4.0
	"
DEPEND="${RDEPEND}"
