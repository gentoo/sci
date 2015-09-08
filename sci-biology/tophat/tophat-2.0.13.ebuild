# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes
PYTHON_COMPAT=( python2_7 )

inherit autotools-utils python-single-r1

DESCRIPTION="Python-based splice junction mapper for RNA-Seq reads using bowtie/bowtie2"
HOMEPAGE="http://ccb.jhu.edu/software/tophat"
# https://github.com/infphilo/tophat
# http://ccb.jhu.edu/software/tophat/downloads/tophat-2.0.14.tar.gz
SRC_URI="http://ccb.jhu.edu/software/tophat/downloads/${P}.tar.gz"

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

# PATCHES=( "${FILESDIR}"/${P}-flags.patch )

src_prepare() {
	sed -e "s#./samtools-0.1.18#"${S}"/src/samtools-0.1.18#g" -i configure* Makefile* || die
	sed -e "s#./SeqAn-1.3#"${S}"/src/SeqAn-1.3#g" -i configure* || die
	# rm -rf src/SeqAn* || die
	eautoreconf
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-optim
		$(use_enable debug)
	)
	autotools-utils_src_configure
	cd ../"${P}"_build/src || die
	ln -s ../"${P}"/src/SeqAn-1.3 . || die
	ln -s ../../"${P}"/src/samtools-0.1.18 . || die
	sed -e "s#./samtools-0.1.18#"${S}"/src/samtools-0.1.18#g" -i Makefile* || die
}

src_install() {
	# introduce empty all-recursive: target in tophat-2.0.14_build/src/Makefile (BUG: does not replace?)
	sed -e "s#^all: all-am#all: all-am\nall-recursive: all#g" -i src/Makefile* || die
	autotools-utils_src_install
	python_fix_shebang "${ED}"/usr/bin/tophat
}
