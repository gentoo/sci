# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes
AUTOTOOLS_IN_SOURCE_BUILD=yes
PYTHON_COMPAT=( python2_7 )

inherit autotools-utils python-single-r1

DESCRIPTION="Python-based splice junction mapper for RNA-Seq reads using bowtie/bowtie2"
HOMEPAGE="http://ccb.jhu.edu/software/tophat"
SRC_URI="https://github.com/infphilo/tophat/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="dev-libs/boost"
# sci-biology/seqan provides binaries and headers but there are no *.so files so no need for a runtime dependency
# boost and seqan is needed for tophat_reporter

# tophat.py calls
#   samtools_0.1.18 view -h -
#   samtools_0.1.18 sort
#   samtools_0.1.18 merge -f -h -u -Q --sam-header
RDEPEND="${DEPEND}
	>=sci-biology/bowtie-0.12.9 || ( >=sci-biology/bowtie-2.0.5 <=sci-biology/bowtie-2.2.3 )"

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)
	autotools-utils_src_configure

	echo "../src/libtophat.a: libtophat.a" >> src/Makefile
	echo "../src/libgc.a: libgc.a" >> src/Makefile
	echo "samtools_0.1.18:" >> src/Makefile
	echo -e "\tcp samtools-0.1.18/\$@ \$@" >> src/Makefile
}
