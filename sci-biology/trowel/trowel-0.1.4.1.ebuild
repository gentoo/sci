# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Error corrector for genomic Illumina FASTQ reads"
HOMEPAGE="http://sourceforge.net/projects/trowel-ec"
SRC_URI="http://downloads.sourceforge.net/project/trowel-ec/src/trowel.0.1.4.1.src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/boost-1.53.0
	>=dev-cpp/sparsehash-2.0.2"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/trowel.0.1.4.1.src
