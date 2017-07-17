# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Correct substitution errors in Illumina reads"
HOMEPAGE="http://www.genome.umd.edu/quorum.html
	https://github.com/gmarcais/Quorum"
SRC_URI="https://github.com/gmarcais/Quorum/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-biology/jellyfish-2.1.4"
RDEPEND="${DEPEND}"

src_configure(){
	econf --enable-relative-paths --with-relative-jf-path
	default
}
