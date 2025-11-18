# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs cmake

DESCRIPTION="Metagenome assembler using succinct de Bruijn graph approach with CUDA"
HOMEPAGE="https://github.com/voutcn/megahit
	http://bioinformatics.oxfordjournals.org/content/31/10/1674.abstract"
SRC_URI="https://github.com/voutcn/megahit/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+openmp cuda"

DEPEND=""
RDEPEND="${DEPEND}
	sys-libs/zlib
	cuda? ( >=dev-util/nvidia-cuda-toolkit-5 dev-libs/cudnn )"
# contains bundled copy og idba from https://github.com/loneknightpy/idba

pkg_setup() {
	use openmp && ! tc-has-openmp && die "Please switch to an openmp compatible compiler"
}

pkg_postinst(){
	einfo "The maximum k-mer size is 255. You can edit kMaxK in definitions.h"
	einfo "and recompile, eventually"
	einfo "If you enabled GPU then use 'megahit --use-gpu' to activate it."
}
