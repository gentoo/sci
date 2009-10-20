# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/clustalw/clustalw-2.0.12.ebuild,v 1.1 2009/10/18 21:14:11 weaver Exp $

EAPI=2

inherit eutils

DESCRIPTION="A tool to facilitate submission of data to the GenBank, EMBL, and DDBJ sequence databases"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/Sequin/"
SRC_URI="amd64? ( ftp://ftp.ncbi.nih.gov/sequin/old/${PV}/sequin.linux-x86_64.tar.gz -> ${P}-x86_64.tar.gz )
	x86? ( ftp://ftp.ncbi.nih.gov/sequin/old/${PV}/sequin.linux-x86.tar.gz -> ${P}-x86.tar.gz )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="x11-libs/libXmu
	x11-libs/libXp"

S="${WORKDIR}"

src_install() {
	insinto /opt/${PN}
	doins -r * || die
	exeinto /opt/${PN}
	doexe sequin || die
	dosym /opt/${PN}/sequin /usr/bin/sequin || die
	make_desktop_entry sequin Sequin || die
}
