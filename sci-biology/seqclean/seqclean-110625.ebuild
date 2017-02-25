# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Trimpoly and mdust for trimming and validation of ESTs/DNA sequences"
HOMEPAGE="http://compbio.dfci.harvard.edu/tgi/software/"
for i in seqcl_scripts mdust trimpoly; do
	SRC_URI="${SRC_URI} ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/seqclean/${i}.tar.gz -> ${i}-${PV}.tar.gz"
done

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-lang/perl
	sci-biology/ncbi-tools"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_prepare() {
	# disable the necessity to install Mailer.pm with this tool
	einfo "Disabling mailer feature within seqclean"
	sed -i 's/use Mailer;/#use Mailer;/' "${S}"/"${PN}"/"${PN}" || die

	epatch "${FILESDIR}"/${P}-build.patch

	tc-export CC CXX
}

src_compile() {
	for i in mdust trimpoly; do
		LDLFAGS="${LDFLAGS}" \
			emake -C "${S}"/${i}
	done
}

src_install() {
	dobin seqclean/{seqclean,cln2qual,bin/seqclean.psx}
	newdoc seqclean/README README.seqclean
	for i in mdust trimpoly; do
		dobin ${i}/${i}
	done

	einfo "Optionally, you may want to download UniVec from NCBI if you do not have your own"
	einfo "fasta file with vector sequences you want to remove from sequencing"
	einfo "reads. See http://www.ncbi.nlm.nih.gov/VecScreen/UniVec.html"
}
