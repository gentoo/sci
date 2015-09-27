# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

DESCRIPTION="Extract ORF/CDS regions from FASTA sequences"
HOMEPAGE="http://sourceforge.net/projects/transdecoder/"
SRC_URI="https://github.com/TransDecoder/TransDecoder/archive/"${PV}".tar.gz -> ${P}.tar.gz"

LICENSE="BSD-BroadInstitute"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/cd-hit
	sci-biology/hmmer
	sci-biology/parafly
	sci-biology/ffindex"
# cdhit-4.6.1 is a real dependency, at least hmmer is optional (also ncbi-tools++ is now used for ORF searches)

S="${WORKDIR}"/TransDecoder-2.0.1

##src_prepare(){
#	#mv Makefile Makefile.old
#	#epatch "${FILESDIR}"/TransDecoder.patch
#	#epatch "${FILESDIR}"/pfam_runner.pl.patch
#}

# avoid fetching 1.5TB "${S}"/pfam/Pfam-AB.hmm.bin, see
# "Re: [Transdecoder-users] Announcement: Transdecoder release r20140704" thread in archives
#
# you cna get it from http://downloads.sourceforge.net/project/transdecoder/Pfam-AB.hmm.bin

src_install(){
	dobin TransDecoder.Predict TransDecoder.LongOrfs
	insinto /usr/share/${PN}/util
	dobin util/*.pl
	# zap the bundled cdhit binaries copied from transdecoder_plugins/cdhit/ to util/bin
	rm -rf util/bin
	#
	#  * sci-biology/trinityrnaseq-20140413:0::science
	# *      /usr/bin/Fasta_reader.pm
	# *      /usr/bin/GFF3_utils.pm
	# *      /usr/bin/Gene_obj.pm
	# *      /usr/bin/Gene_obj_indexer.pm
	# *      /usr/bin/Longest_orf.pm
	# *      /usr/bin/Nuc_translator.pm
	# *      /usr/bin/TiedHash.pm
	#
	perl_set_version
	insinto ${VENDOR_LIB}/${PN}
	dobin PerlLib/*.pm # BUG: install into /usr/bin but wanted to have it readable and executable in ${VENDOR_LIB}/${PN} instead
	einfo "Fetch on your own:"
	einfo "wget --mirror -nH -nd http://downloads.sourceforge.net/project/transdecoder/Pfam-AB.hmm.bin"
	einfo "hmmpress Pfam-AB.hmm.bin"
}

pkg_postinst(){
	einfo "It is recommended to use TransDecoder with hmmer-3 or at least NCBI blast"
	einfo "from either sci-biology/ncbi-blast+ (released more often) or"
	einfo "from sci-biology/ncbi-toolkit++ (huge bundle with releases and less frequent bugfixes)"
	einfo "Author says the minimum requirement is sci-biology/cd-hit"
}
