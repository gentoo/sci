# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="A FASTA record indexing/retrievieng utility, a part of TIGR Gene Indices project tools"
HOMEPAGE="http://compbio.dfci.harvard.edu/tgi/software"
SRC_URI="ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/cdbfasta/cdbfasta.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack cdbfasta.tar.gz
}

src_compile() {
	sed -i 's/CFLAGS[ ]*=/CFLAGS :=/; s/-D_REENTRANT/-D_REENTRANT \${CFLAGS}/; s/CFLAGS[ ]*:=[ ]*-O2$//' "${S}"/Makefile || die "Failed to patch Makefile"
	sed -i 's/-march=i686//' "${S}"/Makefile || die
	sed -i 's/-O2 //' "${S}"/Makefile || die
	emake || die "emake failed"
}

src_install() {
	dobin {cdbfasta,cdbyank} || die "Failed to install binaries"
	newdoc README README.${PN} || die
}
