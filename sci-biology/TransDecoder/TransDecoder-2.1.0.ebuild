# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-functions toolchain-funcs

DESCRIPTION="Extract ORF/CDS regions from FASTA sequences"
HOMEPAGE="http://transdecoder.github.io"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TransDecoder/TransDecoder.git"
else
	SRC_URI="https://github.com/TransDecoder/TransDecoder/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-BroadInstitute"
SLOT="0"
IUSE=""

DEPEND="dev-lang/perl:="
RDEPEND="${DEPEND}
	sci-biology/cd-hit
	sci-biology/parafly
	sci-biology/ffindex"

src_prepare() {
	rm -rf transdecoder_plugins/cd-hit || die
	local f p
	for f in PerlLib/*.pm; do
		p=$(basename $f .pm)

		sed -e "s#use $p;#use TransDecoder::$p;#" \
			-i PerlLib/*.pm util/*.pl TransDecoder.LongOrfs TransDecoder.Predict || die
	done
	eapply "${FILESDIR}"/"${P}"__fix_paths.patch
	eapply "${FILESDIR}"/pfam_runner.pl.patch

	eapply_user
}

src_compile() {
	einfo "Skipping compilation of bundled cd-hit code, nothing else to do"
}

# avoid fetching 1.5TB "${S}"/pfam/Pfam-AB.hmm.bin, see
# "Re: [Transdecoder-users] Announcement: Transdecoder release r20140704"
# thread in archives. You can get it from
# http://downloads.sourceforge.net/project/transdecoder/Pfam-AB.hmm.bin

src_install() {
	dobin TransDecoder.Predict TransDecoder.LongOrfs

	insinto /usr/share/${PN}/util
	doins util/*.pl

	chmod -R a+rx "${ED%/}"/usr/share/${PN}/util || die
	# zap the bundled cdhit binaries copied from transdecoder_plugins/cdhit/ to util/bin
	rm -rf util/bin || die

	perl_domodule -C ${PN} PerlLib/*.pm

	# dodoc Release.Notes
	einfo "Fetch your own Pfam-A.hmm (Pfam-AB.hmm is discontinued since 05/2015):"
	einfo "wget --mirror -nH -nd ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz"
	einfo "hmmpress Pfam-A.hmm.bin"
}

pkg_postinst() {
	einfo "It is recommended to use TransDecoder with sci-biology/hmmer-3 or"
	einfo "at least with NCBI blast from either:"
	einfo "    sci-biology/ncbi-blast+ (released more often) or from"
	einfo "    sci-biology/ncbi-toolkit++ (a huge bundle with releases and less frequent bugfixes)"
}
