# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit perl-module

DESCRIPTION="Extract ORF/CDS regions from FASTA sequences"
HOMEPAGE="http://sourceforge.net/projects/transdecoder/"
SRC_URI="http://downloads.sourceforge.net/project/transdecoder/TransDecoder_r20140704.tar.gz"

LICENSE="BSD-BroadInstitute"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-cluster/openmpi
	sci-biology/hmmer
	sci-biology/cd-hit
	sci-biology/parafly
	sci-biology/ffindex"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/TransDecoder_r20140704

src_prepare(){
	rm -rf 3rd_party
	mv Makefile Makefile.old
}

# avoid fetching 1.5TB "${S}"/pfam/Pfam-AB.hmm.bin, see
# "Re: [Transdecoder-users] Announcement: Transdecoder release r20140704" thread in archives
#
# you cna get it from http://downloads.sourceforge.net/project/transdecoder/Pfam-AB.hmm.bin

src_install(){
	dobin TransDecoder *.pl util/*.pl util/*.sh
	eval `perl '-V:installvendorlib'`
	vendor_lib_install_dir="${installvendorlib}"
	dodir ${vendor_lib_install_dir}
	insinto ${vendor_lib_install_dir}
	doins PerlLib/*.pm
}
