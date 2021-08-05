# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="SEquence Error Corrector for RNA-Seq reads"
HOMEPAGE="http://sb.cs.cmu.edu/seecer/"
SRC_URI="
	http://sb.cs.cmu.edu/seecer/downloads/"${P}".tar.gz
	http://sb.cs.cmu.edu/seecer/downloads/manual.pdf -> "${PN}"-manual.pdf"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

# although has bundled jellyfish-1.1.11 copy it just calls the executable during runtime
# seems jellyfish-2 does not accept same commandline arguments
DEPEND="
	sci-libs/gsl:0=
	sci-biology/seqan:0="
RDEPEND="${DEPEND}
	sci-biology/jellyfish:1"

S="${WORKDIR}/${P}/SEECER"

PATCHES=(
	"${FILESDIR}"/remove-hardcoded-paths.patch
	"${FILESDIR}"/run_seecer.sh.patch
	"${FILESDIR}"/run_jellyfish.sh.patch
	"${FILESDIR}"/${PN}-increase-max-sequence-length.patch
	"${FILESDIR}"/${PN}-remove-flags.patch
)

pkg_pretend(){
	# openmp is a hard requirement due to no gomp switch and source code assuming it is available
	[[ ${MERGE_TYPE} != "binary" ]] && tc-check-openmp
}

pkg_setup(){
	[[ ${MERGE_TYPE} != "binary" ]] && tc-check-openmp
}

src_prepare(){
	rm bin/.run*.swp || die
	rm src/*.o pipeline/*.o || die
	rm -r seqan-cxx || die
	default
	eautoreconf -i
}

src_configure(){
	econf \
		--with-seqan-include-path=/usr/include/seqan \
		CXXFLAGS="${CXXFLAGS}"
}

src_install(){
	dobin bin/seecer bin/random_sub_N bin/replace_ids bin/run_jellyfish.sh bin/run_seecer.sh
	dodoc README "${DISTDIR}"/"${PN}"-manual.pdf
}

pkg_postinst(){
	einfo "Note that the default kmer size 17 is terribly suboptimal, use k=31 instead"
}
