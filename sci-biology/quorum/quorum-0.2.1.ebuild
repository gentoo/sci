# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Correct substitution errors in Illumina reads"
HOMEPAGE="http://www.genome.umd.edu/quorum.html"
SRC_URI="ftp://ftp.genome.umd.edu/pub/QuorUM/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=sci-biology/jellyfish-1.1.11
		<=sci-biology/jellyfish-2.0.0"
RDEPEND="${DEPEND}"

src_configure(){
	econf --enable-relative-paths --with-relative-jf-path
}
