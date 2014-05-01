# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# inherit

MY_REV="92"

DESCRIPTION="Low Resolution Structure Refinement"
HOMEPAGE="https://simtk.org/home/direx"
SRC_URI="${P}-rev${MY_REV}-linux.tgz"

LICENSE="direx"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="amd64? ( app-emulation/emul-linux-x86-compat )"
DEPEND="${RDEPEND}"

RESTRICT="fetch"

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and download ${A}"
	einfo "into ${DISTDIR}"
}

src_install() {
	exeinto /opt/${PN}/bin
	doexe ${PN} || die

	cat >> "${T}"/20${PN} <<- EOF
	PATH="/opt/${PN}/bin"
	EOF

	doenvd "${T}"/20${PN}

	insinto /usr/share/${PN}
	doins -r tutorial || die
	dohtml doc/* || die
	dodoc README || die
}
