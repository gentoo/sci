# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base

DESCRIPTION="A Hybrid method for predicting protein backbone torsion angles from NMR CS"
HOMEPAGE="http://spin.niddk.nih.gov/bax/software/TALOS+/index.html"
SRC_URI="http://spin.niddk.nih.gov/bax/software/TALOS+/talos+.tar.Z"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/rama+.patch
	)

src_install() {
	sed \
		-e "s:DIR_HERE:/opt/${PN}/:g" \
		-i *+

	insinto /opt/${PN}/
	doins -r test tab rama.{dat,gif} || die

	exeinto /opt/${PN}/bin
	newexe bin/TALOS+.linux TALOS+
	doexe rama+.tcl

	dobin bmrb2talos.com talos2dyana.com talos2xplor.com talos+ rama+ || die



	dodoc README
}
