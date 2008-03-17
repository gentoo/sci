# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="The Gene Index Project utilities for genomic data processing: seqclean, cdbfasta, psx"
HOMEPAGE="http://compbio.dfci.harvard.edu/tgi/software/"

for i in seqclean/{seqclean,mdust,trimpoly} cdbfasta/cdbfasta tgicl/{psx,pvmsx,zmsort,tclust,sclust,nrcl,tgi_cpp_library}; do
	SRC_URI="${SRC_URI} ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/${i}.tar.gz"
done

LICENSE="Artistic"
SLOT="0"
IUSE="pvm"
KEYWORDS="~x86"

DEPEND="pvm? ( sys-cluster/pvm )"
RDEPEND=${DEPEND}

S=${WORKDIR}

src_unpack() {
	unpack {seqclean,mdust,trimpoly,cdbfasta,tgi_cpp_library}.tar.gz
	for i in nrcl sclust tclust zmsort psx pvmsx; do
		mkdir "${S}"/${i}
		cd "${S}"/${i}
		unpack ${i}.tar.gz
	done
}

src_compile() {
	sed -i 's/use Mailer;/#use Mailer;/' ${S}/seqclean/seqclean
	sed -i 's/-V\t\tverbose/-V\t\tverbose\\/' ${S}/zmsort/zmsort.cpp
	# TODO: fix error in nrcl
	for i in cdbfasta mdust psx sclust tclust trimpoly zmsort $(use pvm && echo pvmsx); do
		sed -i 's/CFLAGS[ ]*=/CFLAGS :=/; s/-D_REENTRANT/-D_REENTRANT \${CFLAGS}/; s/CFLAGS[ ]*:=[ ]*-O2$//' ${S}/${i}/Makefile
		cd ${S}/${i} || die "cd ${i} failed"
		emake || die "emake failed in ${i}"
	done
}

src_install() {
	dobin cdbfasta/{cdbfasta,cdbyank} seqclean/{seqclean,cln2qual,bin/seqclean.psx}
	for i in mdust psx sclust tclust trimpoly zmsort $(use pvm && echo pvmsx); do
		dobin ${i}/${i}
	done
	for i in cdbfasta seqclean; do
		newdoc ${i}/README README.${i}
	done
}
