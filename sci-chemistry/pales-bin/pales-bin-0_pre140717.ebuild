# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Prediction of alignment from structure"
HOMEPAGE="http://www3.mpibpc.mpg.de/groups/zweckstetter/_links/software_pales.htm"
SRC_URI="http://www3.mpibpc.mpg.de/groups/zweckstetter/_software_files/_pales/pales-linux -> ${PN}-${PV}"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

QA_PREBUILT="opt/bin/.*"

src_unpack() {
	mkdir "${S}" || die
	cp "${DISTDIR}"/${A} "${S}"/${PN} || die
}

src_install() {
	exeinto /opt/bin
	newexe ${PN} ${PN%-bin}
}
