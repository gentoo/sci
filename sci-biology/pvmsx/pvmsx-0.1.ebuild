# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Parallel multi-FASTA file processing tool"
HOMEPAGE="http://compbio.dfci.harvard.edu/tgi/software/"
SRC_URI="
	ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/${PN}.tar.gz
	ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/cdbfasta.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

#DEPEND="sys-cluster/pvm"
#RDEPEND="${DEPEND}"

S=${WORKDIR}

src_prepare() {
	# we need gclib from cdbfasta.tar.gz bundle which has fewer files than tgi_cpp_library.tar.gz wbut has e.g. GStr.h
	sed \
		-e 's/CFLAGS[ ]*=/CFLAGS :=/; s/-D_REENTRANT/-D_REENTRANT \${CFLAGS}/; s/CFLAGS[ ]*:=[ ]*-O2$//' \
		-i "${S}"/Makefile || die "Failed to run sed"
	sed \
		-e 's#GCLDIR := ../gclib#GCLDIR := ../cdbfasta/gclib#' \
		-i "${S}"/Makefile || die
	sed \
		-e "s#-I-#-iquote#" \
		-i "${S}"/Makefile || die
	ln -s ../cdbfasta/gcl . || die "Cannot make a softlink"
}

src_compile() {
	default
}

src_install() {
	dobin ${PN}
	newdoc README README.${PN}
}
