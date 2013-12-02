# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Gordon Text utils Library"
HOMEPAGE="http://hannonlab.cshl.edu/fastx_toolkit/"
SRC_URI="http://hannonlab.cshl.edu/fastx_toolkit/"${PN}"-"${PV}".tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install(){
	emake install DESTDIR="${D}"
}
