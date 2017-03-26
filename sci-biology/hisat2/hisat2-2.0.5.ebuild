# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Align DNA reads to a population of genomes"
HOMEPAGE="
	https://ccb.jhu.edu/software/hisat2
	https://github.com/infphilo/hisat2"
SRC_URI="ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/${P}-source.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-respect_CXXFLAGS.patch )

# TODO: could depend on sci-biology/ncbi-tools++ or sra_sdk containing ncbi-vdb
# For the support of SRA data access in HISAT2, please download and install the [NCBI-NGS] toolkit.
# When running `make`, specify additional variables as follow.
# `make USE_SRA=1 NCBI_NGS_DIR=/path/to/NCBI-NGS-directory NCBI_VDB_DIR=/path/to/NCBI-NGS-directory`,
# where `NCBI_NGS_DIR` and `NCBI_VDB_DIR` will be used in Makefile for -I and -L compilation options.
# For example, $(NCBI_NGS_DIR)/include and $(NCBI_NGS_DIR)/lib64 will be used.

src_configure(){
	if use cpu_flags_x86_sse2; then
		SSE_FLAGS='-msse2'
	fi
	if [ "$ARCH" = "amd64" ] || [ "$ARCH" = "ia64" ] || [ "$ARCH" = "ppc64" ]; then
		BITS='-m64'
	else
		BITS='-32'
	fi
}

src_compile(){
	emake SSE_FLAG="${SSE_FLAGS}" BITS="${BITS}"
}

src_install(){
	dobin hisat2{,-build,-inspect,-build-s,-build-l,-align-s,-align-l,-inspect-s,-inspect-l}
	python_foreach_impl python_doscript *.py
	insinto /usr/share/"${PN}"/scripts
	doins scripts/*.sh
	dodoc MANUAL TUTORIAL
}
