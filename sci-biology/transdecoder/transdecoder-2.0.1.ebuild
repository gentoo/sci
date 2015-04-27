# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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
	sci-biology/hmmer
	sci-biology/cd-hit
	sci-biology/parafly
	sci-biology/ffindex"

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
	dobin TransDecoder *.pl util/*.pl util/*.sh
	perl_set_version
	insinto ${VENDOR_LIB}/TransDecoder
	dobin PerlLib/*.pm
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
