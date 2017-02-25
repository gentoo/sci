# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Transcriptome de novo assembler with chimera detection"
HOMEPAGE="http://ebardenovo.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/project/ebardenovo/EBARDenovo-1.2.2-20130404.zip"

# This software package (with patent pending) is free of charge for academic use only
LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/mono"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/EBARDenovo-1.2.2-20130404

src_install(){
	dobin EBARDenovo.exe
	dodoc EBARDenovoManual.pdf ReleaseNote.txt README.txt
}
