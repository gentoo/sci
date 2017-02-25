# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module eutils

DESCRIPTION="RNA-Seq Unified Mapper (digital normalization)"
HOMEPAGE="https://github.com/itmat/rum/wiki"
SRC_URI="https://github.com/itmat/rum/archive/v2.0.5_05.tar.gz -> ${P}.tar.gz"

# stable
#EGIT_REPO_URI="https://github.com/PGFI/rum/tags"

# dev
#EGIT_REPO_URI="https://github.com/PGFI/rum"

LICENSE="UPennState"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-perl/Log-Log4perl
	virtual/perl-autodie"
RDEPEND="${DEPEND}
	sci-biology/seqclean
	sci-biology/blat
	sci-biology/bowtie
	sci-biology/seqclean"

S="${WORKDIR}/${PN}-2.0.5_05"

src_install(){
	default
	rm "${ED}"/usr/lib64/perl5/vendor_perl/*/RUM/{bowtie,blat,mdust} ]] die
}
