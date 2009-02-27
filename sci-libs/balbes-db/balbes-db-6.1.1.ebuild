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
	 sci-chemistry/refmac"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

src_compile() {
	:
}

src_install() {
	dodir /usr/share/ccp4/balbes/BALBES_0.0.1
	# We don't want to wait around to copy all this, or suck up double
	# the disk space
	rm -rf "${S}"/share/balbes/BALBES_0.0.1/{bin,bin_py/*.pyc}
	mv "${S}"/share/balbes/BALBES_0.0.1/* "${D}"/usr/share/ccp4/balbes/BALBES_0.0.1/ || die
	fperms 664 /usr/share/ccp4/balbes/BALBES_0.0.1/bin_py/*
	dosym ../share/ccp4/balbes/BALBES_0.0.1/bin_py/balbes /usr/bin/balbes
}

pkg_postinst() {
	python_mod_optimize /usr/share/ccp4/balbes/BALBES_0.0.1/bin_py
}

pkg_postrm() {
	python_mod_cleanup /usr/share/ccp4/balbes/BALBES_0.0.1/bin_py
}

