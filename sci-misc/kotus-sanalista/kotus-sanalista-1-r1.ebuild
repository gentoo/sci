# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P=${PN}-v${PVR}

DESCRIPTION="Finnish dictionary word list"
HOMEPAGE="http://home.gna.org/omorfi/"
SRC_URI="http://download.gna.org/omorfi/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-java/saxon"
RDEPEND=""

S="${WORKDIR}/${MY_P}"
