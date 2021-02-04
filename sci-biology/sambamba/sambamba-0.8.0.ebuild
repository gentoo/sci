# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LZ4_COMMIT="b3692db46d2b23a7c0af2d5e69988c94f126e10a"

DESCRIPTION="Parallell process SAM/BAM/CRAM files faster than samtools"
HOMEPAGE="https://lomereiter.github.io/sambamba/"
SRC_URI="https://github.com/lomereiter/sambamba/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/lz4/lz4/archive/${LZ4_COMMIT}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="debug"

# https://github.com/ldc-developers/gentoo-overlay/tree/master/dev-lang/ldc2
#
# contains bundled htslib
DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	default
	rm -r "${S}/lz4" || die
	mv "${WORKDIR}/lz4-${LZ4_COMMIT}" "${S}/lz4" || die
}

src_compile(){
	if use debug ; then
		emake debug all
	else
		emake all
	fi
}
