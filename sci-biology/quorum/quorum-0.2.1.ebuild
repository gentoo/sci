# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Illumina reads error corrector"
HOMEPAGE="http://www.genome.umd.edu/quorum.html"
SRC_URI="ftp://ftp.genome.umd.edu/pub/QuorUM/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="=sci-biology/jellyfish-1.1.11"
RDEPEND="${DEPEND}"

src_configure(){
	econf --enable-relative-paths --with-relative-jf-path
}
