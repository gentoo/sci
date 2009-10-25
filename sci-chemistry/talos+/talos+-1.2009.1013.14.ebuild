# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="A Hybrid method for predicting protein backbone torsion angles from NMR CS"
HOMEPAGE="http://spin.niddk.nih.gov/bax/software/TALOS+/index.html"
SRC_URI="http://spin.niddk.nih.gov/bax/software/TALOS+/talos+.tar.Z -> ${P}.tar.Z"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/tcl"
DEPEND=""

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/rama+.patch
}

src_install() {
	sed \
		-e "s:DIR_HERE:/opt/${PN}/:g" \
		-i *+

	insinto /opt/${PN}/
	doins -r tab rama.{dat,gif} || die

	exeinto /opt/${PN}/bin
	newexe bin/TALOS+.linux TALOS+ || die
	doexe rama+.tcl || die

	dobin bmrb2talos.com talos2dyana.com talos2xplor.com talos+ rama+ || die

	dodoc README || die
}
