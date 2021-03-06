# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="RNA-Seq Unified Mapper (digital normalization)"
HOMEPAGE="https://github.com/itmat/rum/wiki"
SRC_URI="https://github.com/itmat/rum/archive/v$(ver_rs 3-4 _).tar.gz -> ${P}.tar.gz"

LICENSE="UPennState"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-perl/Log-Log4perl
	virtual/perl-autodie"
RDEPEND="${DEPEND}
	sci-biology/seqclean
	sci-biology/blat
	sci-biology/bowtie
	sci-biology/seqclean"

S="${WORKDIR}/${PN}-$(ver_rs 3-4 _)"

src_install(){
	default
	rm "${ED}"/usr/lib64/perl5/vendor_perl/*/RUM/{bowtie,blat,mdust} ]] || die
}
