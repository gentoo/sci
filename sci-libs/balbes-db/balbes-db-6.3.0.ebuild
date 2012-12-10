# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/balbes-db/balbes-db-6.1.3-r1.ebuild,v 1.2 2011/11/21 15:29:17 jlec Exp $

EAPI=4

MY_P="ccp4-${PV}"

SRC="ftp://ftp.ccp4.ac.uk/ccp4"

DESCRIPTION="The database for the BALBES automated crystallographic molecular replacement pipeline"
HOMEPAGE="http://www.ysbl.york.ac.uk/~fei/balbes/"
SRC_URI="${SRC}/${PV}/${MY_P}-${PN/-/}.tar.gz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="sci-libs/monomer-db"
DEPEND="${RDEPEND}"

RESTRICT="binchecks strip"

S="${WORKDIR}/${MY_P}"

src_install() {
	dodir /usr/share/balbes/
	find share/BALBES/Package/dic -delete || die
	# We don't want to wait around to copy all this, or suck up double
	# the disk space
	einfo "Installing files, which can take some time ..."
	mv "${S}"/share/BALBES "${ED}"/usr/share/ || die
	# db files shouldn't be executable
	find "${ED}"/usr/share/BALBES \
		-type f \
		-exec chmod 664 '{}' + || die
	dosym ../../ccp4/data/monomers /usr/share/BALBES/Package/dic || die

	cat >> "${T}"/20balbes <<- EOF
	BALBES_ROOT="${EPREFIX}/usr/share/BALBES/Package"
	EOF

	doenvd "${T}"/20balbes
}
