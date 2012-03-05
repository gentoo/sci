# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="RNA-Seq assembly and analysis tool of SAM/BAM file inputs"
HOMEPAGE="http://cufflinks.cbcb.umd.edu"
SRC_URI="http://cufflinks.cbcb.umd.edu/downloads/"${PN}"-"${PV}".tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/boost
		sci-libs/lemon
		sys-libs/zlib"
RDEPEND="${DEPEND}
		sci-biology/tophat"
