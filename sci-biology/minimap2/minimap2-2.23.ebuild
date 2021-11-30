# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="splice-aware sequence aligner with SSE2 and SSE4.1"
HOMEPAGE="https://github.com/lh3/minimap2"
SRC_URI="https://github.com/lh3/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+static"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare(){
	sed -e 's/-O2 //' -e 's/^CFLAGS=/CFLAGS+=/' -i Makefile || die
	eapply_user
}

# Minimap2 requires SSE2 instructions on x86 CPUs or NEON on ARM CPUs. It is
# possible to add non-SIMD support, but it would make minimap2 slower by
# several times.
#
# If you see compilation errors, try `make sse2only=1`
# to disable SSE4 code, which will make minimap2 slightly slower.
#
# Minimap2 also works with ARM CPUs supporting the NEON instruction sets. To
# compile for 32 bit ARM architectures (such as ARMv7), use `make arm_neon=1`. To
# compile for for 64 bit ARM architectures (such as ARMv8), use `make arm_neon=1
# aarch64=1`.
#
# Minimap2 can use [SIMD Everywhere (SIMDe)][simde] library for porting
# implementation to the different SIMD instruction sets. To compile using SIMDe,
# use `make -f Makefile.simde`. To compile for ARM CPUs, use `Makefile.simde`
# with the ARM related command lines given above.

# This repository also provides Python bindings to a subset of C APIs. File
# [python/README.rst](python/README.rst) gives the full documentation;
# [python/minimap2.py](python/minimap2.py) shows an example. This Python
# extension, mappy, is also [available from PyPI][mappypypi] via `pip install
# mappy` or [from BioConda][mappyconda] via `conda install -c bioconda mappy`.

src_install(){
	dobin "${PN}"
	insinto /usr/include
	doins minimap.h mmpriv.h
	dolib.a libminimap2.a
	insinto /usr/share/"${PN}"/examples
	doins example.c
	doman minimap2.1
	dodoc README.md NEWS.md FAQ.md
}
