# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Visualisation and analysis of processed NMR data"
HOMEPAGE="http://www.onemoonscientific.com/nmrview/"
SRC_URI="
	${PN}${PV}.lib.tar.gz
	${PN}${PV//./_}_01_linux.gz"

SLOT="0"
LICENSE="all-rights-reserved"
IUSE=""
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="x11-libs/libX11"
DEPEND=""

RESTRICT="fetch"

S="${WORKDIR}"

INSTDIR="/opt/nmrview"

QA_PREBUILT="/opt/nmrview/nmrview5_2_2_01_linux"

pkg_nofetch() {
	einfo "Please visit:"
	einfo "\t${HOMEPAGE}"
	echo
	einfo "Complete the registration process, then download the following files:"
	einfo "\t${A}"
	echo
	einfo "Place the downloaded files in your distfiles directory:"
	einfo "\t${DISTDIR}"
	echo
}

src_install() {
	insinto ${INSTDIR}

	sed \
		-e "s:/opt:${EPREFIX}/opt:g" \
		"${FILESDIR}"/${PN}.sh-r1 \
		> "${T}"/${PN} || die

	dobin "${T}"/${PN}
	exeinto ${INSTDIR}
	doexe ${PN}${PV//./_}_01_linux

	DIRS="help html images nvtcl nvtclC nvtclExt reslib star tcl8.4 tk8.4 tools"
	doins -r ${DIRS}

	dodoc "${FILESDIR}"/README.Gentoo
	doins README
	dosym ${INSTDIR}/html /usr/share/doc/${PF}/html
	dosym ${INSTDIR}/README /usr/share/doc/${PF}/README
}
