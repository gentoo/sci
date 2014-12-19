# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools-utils

FULLVER=${PV}-release-20141201090944

DESCRIPTION="Library for biobambam"
HOMEPAGE="https://github.com/gt1/libmaus"
SRC_URI="https://github.com/gt1/libmaus/archive/${FULLVER}.tar.gz"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}-${FULLVER}
