# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FULLVER=${PV}-release-20141201090944

DESCRIPTION="Library for biobambam"
HOMEPAGE="https://github.com/gt1/libmaus"
SRC_URI="https://github.com/gt1/libmaus/archive/${FULLVER}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S="${WORKDIR}"/${PN}-${FULLVER}
