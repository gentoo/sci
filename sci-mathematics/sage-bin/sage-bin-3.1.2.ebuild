# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P/-bin/}"

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography,
and numerical computation."
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://sagemath.org/bin/linux/32bit/${MY_P}-redhat5-i686-32bit-intel-i686-Linux.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""

RDEPEND=">=virtual/jre-1.4
	${DEPEND}"


src_install() {
	dodir /opt/sage-bin
	mv sage-*/ "${D}"/opt/sage-bin
	dosym /opt/sage-bin/sage-*/sage /usr/bin/sage
}


pkg_postinst() {
	# Running corrects all paths to the new location
	/usr/bin/sage <<< quit
}
