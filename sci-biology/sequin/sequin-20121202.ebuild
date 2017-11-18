# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Facilitate submission of data to the GenBank, EMBL, and DDBJ sequence databases"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/Sequin/"
SRC_URI="
	amd64? ( ftp://ftp.ncbi.nih.gov/sequin/sequin.linux-x86_64.tar.gz -> ${P}-x86_64.tar.gz )
	x86? ( ftp://ftp.ncbi.nih.gov/sequin/sequin.linux.tar.gz -> ${P}-x86.tar.gz )"
#	amd64? ( ftp://ftp.ncbi.nih.gov/sequin/old/${PV}/sequin.linux-x86_64.tar.gz -> ${P}-x86_64.tar.gz )
#	x86? ( ftp://ftp.ncbi.nih.gov/sequin/old/${PV}/sequin.linux-x86.tar.gz -> ${P}-x86.tar.gz )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	x11-libs/libXmu
	x11-libs/libXp
"

S="${WORKDIR}"

QA_PREBUILT="/opt/.*"

src_install() {
	dohtml -r *htm images
	rm -rf *htm images || die

	insinto /opt/${PN}
	doins -r *

	exeinto /opt/${PN}
	doexe sequin

	dosym ../${PN}/sequin /opt/bin/sequin

	make_desktop_entry sequin Sequin
}
