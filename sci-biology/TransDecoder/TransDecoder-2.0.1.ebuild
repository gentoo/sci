# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

[ "$PV" == "9999" ] && inherit git-r3

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

DESCRIPTION="Extract ORF/CDS regions from FASTA sequences"
HOMEPAGE="http://transdecoder.github.io"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/TransDecoder/TransDecoder.git"
	KEYWORDS=""
else
    SRC_URI="https://github.com/TransDecoder/TransDecoder/archive/"${PV}".tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}"/TransDecoder-"${PV}"
fi

LICENSE="BSD-BroadInstitute"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/cd-hit
	sci-biology/parafly
	sci-biology/ffindex"

src_prepare(){
	rm -rf transdecoder_plugins/cd-hit
	for f in PerlLib/*.pm; do
		p=`basename $f .pm`;
		sed -e "s#use $p;#use TransDecoder::$p;#" -i PerlLib/*.pm util/*.pl TransDecoder.LongOrfs TransDecoder.Predict;
	done
	epatch "${FILESDIR}"/"${P}"__fix_paths.patch
	epatch "${FILESDIR}"/pfam_runner.pl.patch
}

src_compile(){
	einfo "Skipping compilation of bundled cd-hit code, nothing else to do"
}

# avoid fetching 1.5TB "${S}"/pfam/Pfam-AB.hmm.bin, see
# "Re: [Transdecoder-users] Announcement: Transdecoder release r20140704"
# thread in archives. You can get it from 
# http://downloads.sourceforge.net/project/transdecoder/Pfam-AB.hmm.bin

src_install(){
	dobin TransDecoder.Predict TransDecoder.LongOrfs
	insinto /usr/share/${PN}/util
	doins util/*.pl
	chmod -R a+rx "${D}"/usr/share/${PN}/util
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
	doins PerlLib/*.pm
	dodoc Release.Notes
	einfo "Fetch on your own Pfam-A.hmm (Pfam-AB.hmm is discontinued since 05/2015):"
	einfo "wget --mirror -nH -nd ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz"
	einfo "hmmpress Pfam-A.hmm.bin"
}

pkg_postinst(){
	einfo "It is recommended to use TransDecoder with sci-biology/hmmer-3 or"
	einfo "at least with NCBI blast from either:"
	einfo "    sci-biology/ncbi-blast+ (released more often) or from"
	einfo "    sci-biology/ncbi-toolkit++ (a huge bundle with releases and less frequent bugfixes)"
}
