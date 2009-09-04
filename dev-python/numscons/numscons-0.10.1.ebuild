# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils versionator

MP="$(get_version_component_range 1-2)"

DESCRIPTION="Support library for building numpy with scons"
HOMEPAGE="http://github.com/cournape/numscons/tree/master"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.bz2"

DEPEND="dev-util/scons"
#yes, it needs scons to work
RDEPEND="dev-util/scons"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
