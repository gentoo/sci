# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Protein conformations around a known structure based on geometric restrictions"
HOMEPAGE="http://www.mpibpc.mpg.de/groups/de_groot/concoord/concoord.html"
SRC_URI="
	amd64? ( http://www.mpibpc.mpg.de/groups/de_groot/concoord/concoord2.1_linux_x86_64.tgz )
	x86? ( http://www.mpibpc.mpg.de/groups/de_groot/concoord/concoord2.1_linux_i386.tgz )"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="all-rights-reserved"
IUSE=""

QA_PREBUILT="opt/${PN}/bin/*"

S="${WORKDIR}"/${PN}${PV}

src_install() {
	insinto /opt/${PN}/
	rm lib/*.a || die
	doins -r lib
	exeinto /opt/${PN}/bin
	doexe bin/*
	cat >> "${T}"/60${PN} <<- EOF
	CONCOORDLIB="${EPREFIX}/opt/${PN}/lib"
	CONCOORDBIN="${EPREFIX}/opt/${PN}/bin"
	PATH="${EPREFIX}/opt/${PN}/bin"
	EOF
	doenvd "${T}"/60${PN}
}
