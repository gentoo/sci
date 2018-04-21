# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

DESCRIPTION="Correct substitution errors in Illumina reads"
HOMEPAGE="http://www.genome.umd.edu/quorum.html"
SRC_URI="ftp://ftp.genome.umd.edu/pub/QuorUM/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sci-biology/jellyfish:1"
RDEPEND="${DEPEND}"

src_prepare(){
	default
	epatch "${FILESDIR}"/"${P}"-use-jellyfish1.patch
	eautoreconf
}

src_configure(){
	econf --enable-relative-paths --with-relative-jf-path
}
