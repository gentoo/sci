# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit rpm xdg

DESCRIPTION="Software for plasmid mapping, primer design, and restriction site analysis"
HOMEPAGE="https://www.snapgene.com/snapgene-viewer"
SRC_URI="${PN}_${PV}_linux.rpm"
S="${WORKDIR}"

LICENSE="snapgene"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="bindist fetch"
QA_PREBUILT="*"

pkg_nofetch() {
	elog "Please download ${SRC_URI} from:"
	elog "${HOMEPAGE}"
	elog "and place it at your DISTDIR directory."
}

src_unpack() {
	:
}

src_install() {
	dodir /
	cd "${ED}" || die
	rpm_src_unpack

	# Clean cruft
	rm -rf "${ED}"/usr/lib/.build-id || die
	rm -rf "${ED}"/usr/share/doc/snapgene || die

	sed -i -e 's/Application;//' \
		"${ED}"/usr/share/applications/snapgene.desktop || die
	sed -i -e 's#application/x-dna;application/x-dna;##' \
		"${ED}"/usr/share/applications/snapgene.desktop || die
}
