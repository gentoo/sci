# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils versionator

MP="$(get_version_component_range 1-2)"

DESCRIPTION="Support library for building numpy with scons"
HOMEPAGE="http://github.com/cournape/numscons/tree/master"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.bz2"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"

DEPEND="dev-util/scons"
#yes, it needs scons to work
RDEPEND="dev-util/scons"
