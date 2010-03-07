# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Visualisation and analysis of processed NMR data"
LICENSE="as-is"
HOMEPAGE="http://www.onemoonscientific.com/nmrview/"
SRC_URI="${PN}${PV}.lib.tar.gz
	${PN}${PV//./_}_01_linux.gz"
RESTRICT="fetch"

SLOT="0"
IUSE=""
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="x11-libs/libX11"

S="${WORKDIR}"

INSTDIR="/opt/nmrview"

pkg_nofetch() {
	einfo "Please visit:"
	einfo "\t${HOMEPAGE}"
	einfo
	einfo "Complete the registration process, then download the following files:"
	einfo "\t${A}"
	einfo
	einfo "Place the downloaded files in your distfiles directory:"
	einfo "\t${DISTDIR}"
	echo
}

src_compile() {
	echo
	einfo "Nothing to compile."
	echo
}

src_install() {
	insinto ${INSTDIR}

	sed \
		-e "s:/opt:${EPREFIX}/opt:g" \
		"${FILESDIR}"/${PN}.sh-r1 \
		> "${T}"/${PN}
	dobin "${T}"/${PN} || die "Failed to install wrapper script"
	exeinto ${INSTDIR}
	doexe ${PN}${PV//./_}_01_linux || die "Failed to install binary."

	DIRS="help html images nvtcl nvtclC nvtclExt reslib star tcl8.4 tk8.4 tools"
	doins -r ${DIRS} || die "Failed to install shared files."

	dodoc "${FILESDIR}"/README.Gentoo || die "Failed to install Gentoo README."
	doins README || die "Failed to install README."
	dosym ${INSTDIR}/html /usr/share/doc/${PF}/html || die \
		"Failed to link HTML documentation."
	dosym ${INSTDIR}/README /usr/share/doc/${PF}/README || die \
		"Failed to link README."
}
