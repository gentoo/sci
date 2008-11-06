# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P/-bin/}"
MY_SRC="${MY_P}-rhel5-32bitIntelXeon-i686-Linux"

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography,
and numerical computation."
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://sagemath.org/bin/linux/32bit/${MY_SRC}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""

RDEPEND=">=virtual/jre-1.4
	${DEPEND}"


src_install() {
	dodir /opt/sage-bin
	mv "${MY_SRC}" "${D}"/opt/sage-bin
	dosym /opt/sage-bin/"${MY_SRC}"/sage /usr/bin/sage
}


pkg_postinst() {
	# Running corrects all paths to the new location
	/usr/bin/sage <<< quit
}

