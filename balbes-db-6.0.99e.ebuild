# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="ccp4-${PV}"
DESCRIPTION="The database for the BALBES automated crystallographic molecular replacement pipeline"
HOMEPAGE="http://www.ysbl.york.ac.uk/~fei/balbes/"
SRC_URI="ftp://ftp.ccp4.ac.uk/ccp4/6.1/${MY_P}-${PN/-/_}.tar.gz"
LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

src_compile() {
	:
}

src_install() {
	dodir /usr/share/ccp4/balbes/BALBES_0.0.1
	# We don't want to wait around to copy all this, or suck up double 
	# the disk space
	mv "${S}"/share/balbes/BALBES_0.0.1/* "${D}"/usr/share/ccp4/balbes/BALBES_0.0.1/ || die
}
