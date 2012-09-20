# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="An extensible Molecular Modelling System"
HOMEPAGE="http://www.cgl.ucsf.edu/chimera"
SRC_URI="
	amd64? ( chimera-1.6.2-linux_x86_64.bin )
	x86? ( chimera-1.6.2-linux.bin )"

SLOT="0"
LICENSE="chimera"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"

RESTRICT="fetch"

QA_PREBUILT="opt/.*"

pkg_nofetch() {
	elog "Please visit"
	elog "http://www.cgl.ucsf.edu/chimera/download.html"
	elog "and download ${A} into ${DISTDIR}"
}

src_unpack() {
	cp "${DISTDIR}"/${A} ${A}.zip
	unzip ${A}.zip || die
}

src_install() {
	chmod +x ./chimera.bin
	dodir /opt/
	./chimera.bin -d foo || die
	doicon foo/chimeraIcon.png
	mv foo "${ED}/opt/${PN}" || die

	cat >> "${T}"/chimera <<- EOF
	#!${EPREFX}/bin/bash

	export PATH="${EPREFIX}/opt/${PN}/bin:\${PATH}"
	"${EPREFIX}/opt/${PN}/bin/chimera" \$@
	EOF

	exeinto /opt/bin/
	doexe "${T}"/chimera

	make_desktop_entry "${EPREFIX}/opt/bin/chimera" Chimera chimeraIcon
}
