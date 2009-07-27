# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="ccp4-${PV}"

SRC="ftp://ftp.ccp4.ac.uk/ccp4"

DESCRIPTION="The database for the BALBES automated crystallographic molecular replacement pipeline"
HOMEPAGE="http://www.ysbl.york.ac.uk/~fei/balbes/"
#SRC_URI="${SRC}/${PV}/${MY_P}-${PN/-/_}.tar.gz"
SRC_URI="${SRC}/${PV}/${MY_P}-${PN/-/}-10-11-08.tar.gz"
LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND=">=dev-python/pyxml-0.8.4
	>=sci-chemistry/ccp4-6.1
	sci-chemistry/refmac
	sci-libs/monomer-db"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"
RESTRICT="binchecks strip"

src_compile() {
	:
}

src_install() {
	dodir /usr/share/balbes/BALBES_0.0.1
	rm -rf share/balbes/BALBES_0.0.1/dic
	# We don't want to wait around to copy all this, or suck up double
	# the disk space
	mv "${S}"/share/balbes/BALBES_0.0.1/* "${D}"/usr/share/balbes/BALBES_0.0.1/ || die
	# db files should be executable
	find "${D}"/usr/share/balbes/BALBES_0.0.1/ \
		-type f \
		-exec chmod 664 '{}' \;
	dosym ../../../ccp4/data/monomers /usr/share/balbes/BALBES_0.0.1/dic
}
