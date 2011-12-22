# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

MY_P="UNIO10-Distribution21Dec2011"

DESCRIPTION="Automated NMR Data Analysis"
HOMEPAGE="http://perso.ens-lyon.fr/torsten.herrmann/Herrmann/Software.html"
#SRC_URI="http://perso.ens-lyon.fr/torsten.herrmann/Academic//Academic_Download_files/${MY_P}.tar.gz"
SRC_URI="${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="unio"
IUSE=""

RDEPEND="
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-gtklibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-xlibs )"
DEPEND=""

S="${WORKDIR}/UNIO_10"
RESTRICT="fetch"

QA_DT_HASH="
	opt/unio/Unio10/Linux/Externals/revzip.so
	opt/unio/Unio10/Linux/Unio10
	opt/unio/UnioAlgorithms/unio-2.0.1/src/unio/unioexe.*"
QA_TEXTRELS="opt/unio/Unio10/Linux/Externals/revzip.so"
QA_PRESTRIPPED="
	opt/unio/Unio10/Linux/Externals/revzip.so
	opt/unio/Unio10/Linux/Unio10"
QA_EXECSTACK="opt/unio/UnioAlgorithms/unio-2.0.1/src/unio/unioexe.*"

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE}"
	einfo "and fetch ${A}"
	einfo "into ${DISTDIR}"
}

src_install() {
	mv Unio\'10 Unio10 || die
	mv Unio10/Linux/{Unio\'10,Unio10} || die
	rm -rf \
		Unio10/MacOSX \
		UnioAlgorithms/.DS_Store \
		UnioAlgorithms/unio-2.0.1/src/unio/unioexe.Darwin* \
		UnioAlgorithms/unio-2.0.1/src/echo/libEcho.a \
		UnioAlgorithms/unio-2.0.1/License.pdf || die
	insinto /opt/${PN}
	doins -r Unio10 UnioAlgorithms UnioDocumentations || die
	fperms 755 \
		/opt/${PN}/Unio10/Linux/Unio10 \
		/opt/${PN}/Unio10/Linux/Externals/revzip.so || die
	chmod 755 \
		"${ED}"/opt/${PN}/UnioAlgorithms/${PN}-2.0.1/bin/* \
		"${ED}"/opt/${PN}/UnioAlgorithms/${PN}-2.0.1/src/${PN}/* || die

	cat >> "${T}/${PN}" <<- EOF
	#!/bin/bash
	cd "${EPREFIX}/opt/${PN}"
	exec Unio10/Linux/Unio10 \$@
	EOF

	dobin "${T}/${PN}" || die
}
