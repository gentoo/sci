# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="FASTA record indexing/retrievieng utility"
HOMEPAGE="http://compbio.dfci.harvard.edu/tgi/software"
SRC_URI="ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/cdbfasta/cdbfasta.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_prepare() {
	sed \
		-e 's/CFLAGS[ ]*=/CFLAGS :=/; s/-D_REENTRANT/-D_REENTRANT \${CFLAGS}/; s/CFLAGS[ ]*:=[ ]*-O2$//' \
		-i "${S}"/Makefile || die "Failed to patch Makefile"
	sed -i 's/-march=i686//' "${S}"/Makefile || die
	sed -i 's/-O2 //' "${S}"/Makefile || die
}

src_install() {
	dobin {cdbfasta,cdbyank}
	newdoc README README.${PN}
}
