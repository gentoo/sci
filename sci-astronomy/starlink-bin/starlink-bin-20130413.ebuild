# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

SP=starlink
SR=hikianalia
SRC_COM="http://ftp.jach.hawaii.edu/${SP}/${SR}/${SP}-${SR}"

DESCRIPTION="Astronomical data processing software suite"
HOMEPAGE="http://starlink.jach.hawaii.edu/starlink"
SRC_URI="amd64? ( ${SRC_COM}-Linux-64bit.tar.gz )
	x86? ( ${SRC_COM}-Linux-32bit.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND=""
S="${WORKDIR}"

src_install () {
	dodir /usr
	mv star-${SR} "${ED}"/usr || die
	echo >> 99starlink "STARLINK_DIR=${EROOT%/}/usr/star-${SR}"
	doenvd 99starlink
}
