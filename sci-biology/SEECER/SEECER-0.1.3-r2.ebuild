# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="SEquencing Error Corrector for RNA-Seq reads"
HOMEPAGE="http://sb.cs.cmu.edu/seecer/"
SRC_URI="
	http://sb.cs.cmu.edu/seecer/downloads/"${P}".tar.gz
	http://sb.cs.cmu.edu/seecer/downloads/manual.pdf -> "${PN}"-manual.pdf"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# although has bundled jellyfish-1.1.11 copy it just calls the executable during runtime
# seems jellyfish-2 does not accept same commandline arguments
DEPEND="
	sci-libs/gsl
	sci-biology/seqan"
RDEPEND="${DEPEND}
	=sci-biology/jellyfish-1.1.11"

S="${S}"/SEECER

src_prepare(){
	# http://seecer-rna-read-error-correction-mailing-list.21961.x6.nabble.com/Segmentation-fault-in-step-4-td41.html
	cp -p "${FILESDIR}"/replace_ids.cc "${S}"/src/ || die
	epatch "${FILESDIR}"/remove-hardcoded-paths.patch
}

src_install(){
	dobin bin/seecer bin/random_sub_N bin/replace_ids bin/run_jellyfish.sh bin/run_seecer.sh
	dodoc README "${DISTDIR}"/"${PN}"-manual.pdf
}
