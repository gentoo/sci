# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="${PN#lib}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A macromolecular coordinate superposition library"
HOMEPAGE="http://www.bioxray.dk/~mok/ssm.php"
SRC_URI="ftp://ftp.bioxray.au.dk/pub/mok/src/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die
}
