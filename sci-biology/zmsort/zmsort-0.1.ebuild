# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="merge-sort utility for compressed alignment files, with multi-file output option from TIGR Gene Indices project tools"
HOMEPAGE="http://compbio.dfci.harvard.edu/tgi/software/"
SRC_URI="ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/${PN}.tar.gz
		ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/cdbfasta.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_prepare() {
	# we need gclib from cdbfasta.tar.gz bundle which has fewer files than tgi_cpp_library.tar.gz wbut has e.g. GStr.h
	sed -i 's/CFLAGS[ ]*=/CFLAGS :=/; s/-D_REENTRANT/-D_REENTRANT \${CFLAGS}/; s/CFLAGS[ ]*:=[ ]*-O2$//' "${S}"/${PN}/Makefile || die "Failed to run sed"
	sed -i 's#GCLDIR := ../gclib#GCLDIR := ../cdbfasta/gclib#' "${S}"/"${PN}"/Makefile || die
	sed -i 's/-V\t\tverbose/-V\t\tverbose\\/' "${S}"/"${PN}"/zmsort.cpp || die
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
	newdoc README README.${PN} || die
}
