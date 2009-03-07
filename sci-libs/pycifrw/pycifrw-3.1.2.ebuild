# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_PN="PyCifRW"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Provides support for reading and writing of CIF using python"
HOMEPAGE="http://anbf2.kek.jp/CIF/"
SRC_URI="http://anbf2.kek.jp/downloads/CIF/${MY_P}.tar.gz"

LICENSE="ASRP"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
