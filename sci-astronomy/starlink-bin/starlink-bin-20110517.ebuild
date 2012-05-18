# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SP=starlink
SR=kaulia
SRC_COM="http://ftp.jach.hawaii.edu/${SP}/${SR}/${SP}-${SR}"

DESCRIPTION="Astronomical data processing software suite"
HOMEPAGE="http://starlink.jach.hawaii.edu/starlink"
SRC_URI="amd64? ( ${SRC_COM}-linux64.tar.gz )
	x86? ( ${SRC_COM}-linux32.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""
S="${WORKDIR}"

src_install () {
	insinto /usr
	doins -r star-${SR}
	echo >> 99starlink "STARLINK_DIR=${EPREFIX}/usr/star-${SR}"
	doenvd 99starlink
}
