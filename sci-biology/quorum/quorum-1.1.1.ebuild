# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Correct substitution errors in Illumina reads"
HOMEPAGE="http://www.genome.umd.edu/quorum.html
	https://github.com/gmarcais/Quorum"
SRC_URI="https://github.com/gmarcais/Quorum/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=sci-biology/jellyfish-2.1.4:2"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	# fix jellyfish include path
	find -type f -name "*.cc" -exec sed -i -e 's/<jellyfish\//<jellyfish2\//g' {} + || die
	find -type f -name "*.hpp" -exec sed -i -e 's/<jellyfish\//<jellyfish2\//g' {} + || die
}

src_configure(){
	econf --enable-relative-paths --with-relative-jf-path
	default
}
