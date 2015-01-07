# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="parallel multi-FASTA file processing tool using PVM from TIGR Gene Indices project tools, an alternative to psx"
HOMEPAGE="http://compbio.dfci.harvard.edu/tgi/software/"
SRC_URI="ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/${PN}.tar.gz
		ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/cdbfasta.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pvm"

DEPEND="pvm? ( sys-cluster/pvm )"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_unpack(){
	mkdir ${PN} || die
	cd ${PN} || die "Failed to chdir"
	unpack ${PN}.tar.gz || die
}

src_prepare() {
	# we need gclib from cdbfasta.tar.gz bundle which has fewer files than tgi_cpp_library.tar.gz wbut has e.g. GStr.h
	sed -i 's/CFLAGS[ ]*=/CFLAGS :=/; s/-D_REENTRANT/-D_REENTRANT \${CFLAGS}/; s/CFLAGS[ ]*:=[ ]*-O2$//' "${S}"/${PN}/Makefile || die "Failed to run sed"
	sed -i 's#GCLDIR := ../gclib#GCLDIR := ../cdbfasta/gclib#' "${S}"/"${PN}"/Makefile || die
	sed -i "s#-I-#-iquote#" ${S}/${PN}/Makefile
	cd ${PN} || die
	ln -s ../cdbfasta/gcl . || die "Cannot make a softlink"
}

src_compile() {
	cd ${PN} || die
	emake || die "emake failed in "${S}"/${PN}"
}

src_install() {
	cd ${PN} || die
	dobin ${PN} || die "Failed to install ${PN} binary"
	newdoc README README.${PN}
}
