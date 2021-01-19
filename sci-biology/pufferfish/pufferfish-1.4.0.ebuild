# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

SC_COMMIT="b1de7919c0a4d0e65c5cd0b6d78963516e44be25"
SL_COMMIT="340dad36dff67ca96815bd412fe65587d4d64479"
HL_COMMIT="be22a2a1082f6e570718439b9ace2db17a609eae"

DESCRIPTION="Index for the colored, compacted, de Bruijn graph"
HOMEPAGE="https://github.com/COMBINE-lab/pufferfish"
SRC_URI="https://github.com/COMBINE-lab/pufferfish/archive/salmon-v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/martin-steinegger/setcover/archive/${SC_COMMIT}.tar.gz -> setcover-${P}.tar.gz
	https://github.com/COMBINE-lab/SeqLib/archive/${SL_COMMIT}.tar.gz -> seqlib-${P}.tar.gz
	https://github.com/samtools/htslib/archive/${HL_COMMIT}.tar.gz -> htslib-${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="dev-cpp/tbb"

S="${WORKDIR}/${PN}-salmon-v${PV}"

PATCHES=( "${FILESDIR}/${PN}-do-not-fetch.patch" )

src_prepare() {
	mkdir -p external/{setcover,seqlib}
	mv "../setcover-${SC_COMMIT}"/* external/setcover || die
	mv "../SeqLib-${SL_COMMIT}"/* external/seqlib || die
	mv "../htslib-${HL_COMMIT}"/* external/seqlib/htslib || die
	cmake_src_prepare
}
