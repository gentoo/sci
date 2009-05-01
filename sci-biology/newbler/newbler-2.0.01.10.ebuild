# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/amos/amos-2.0.8.ebuild,v 1.2 2009/03/15 17:58:50 maekke Exp $

EAPI="2"

DESCRIPTION="Roche 454 pyrosequencing assembler"
HOMEPAGE="http://www.454.com/products-solutions/analysis-tools/index.asp"
SRC_URI="offInstrumentApps_2.0.01.10-64.tar.gz"

LICENSE="newbler"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

DEPEND="app-arch/rpm"
RDEPEND=">=virtual/jre-1.6"

RESTRICT="fetch"

S="${WORKDIR}/offInstrumentApps_${PV}-64"

pkg_nofetch() {
	einfo "Please visit ftp://ftp.454.com/ and obtain the file"
	einfo "\"${SRC_URI}\", then place it in ${DISTDIR}"
}

src_prepare() {
	sed -i -e "s|/etc/profile.d|${D}/etc/profile.d|" "${S}/INSTALL" || die
}

src_install() {
	echo -e "\n\n${D}/opt/454\nno\n" | "${S}"/INSTALL || die
	rm -rf "${D}/opt/454/jre" || die
	echo "PATH=/opt/454/bin" > "${S}/99${PN}"
	doenvd "${S}/99${PN}"
}
