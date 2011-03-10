# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Trimpoly and mdust for trimming and validation of ESTs/DNA sequences, low quality and low-complexity sequences with two binaries"
HOMEPAGE="http://compbio.dfci.harvard.edu/tgi/software"
for i in seqclean/{seqcl_scripts,mdust,trimpoly}; do
	SRC_URI="${SRC_URI} ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/${i}.tar.gz"
done

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl
		sci-biology/ncbi-tools"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_unpack() {
	unpack {seqcl_scripts,mdust,trimpoly}.tar.gz
}

src_prepare() {
	# disable the necessity to install Mailer.pm with this tool
	einfo "Disabling mailer feature within seqclean"
	sed -i 's/use Mailer;/#use Mailer;/' "${S}"/"${PN}"/"${PN}" || die

	for i in mdust trimpoly; do
		sed -i 's/CFLAGS[ ]*=/CFLAGS :=/; s/-D_REENTRANT/-D_REENTRANT \${CFLAGS}/; s/CFLAGS[ ]*:=[ ]*-O2$//' "${S}"/${i}/Makefile || die "Failed to run sed"
		sed -i "s#-I-#-iquote#" "${S}"/${i}/Makefile || die "Failed to run sed"
	done
}

src_compile() {
	# seqclean/ contains just perl scripts, no need to compile
	for i in mdust trimpoly; do
		cd "${S}"/${i} || die "Failed to cd "${S}"/${i}"
		emake || die "emake failed in "${S}"/${i}"
	done
}

src_install() {
	dobin seqclean/{seqclean,cln2qual,bin/seqclean.psx} || die "Failed to install the perl-based scripts"
	newdoc seqclean/README README.seqclean
	for i in mdust trimpoly; do
		dobin ${i}/${i} || die "Failed to install ${i} binary"
	done

	einfo "Optionally, you might want to download UniVec from NCBI if you do not have your own"
	einfo "fasta file with vector sequences you want to remove from sequencing"
	einfo "reads. See http://www.ncbi.nlm.nih.gov/VecScreen/UniVec.html"
}
