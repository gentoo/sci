# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Parallell process SAM/BAM/CRAM files faster than samtools"
HOMEPAGE="http://lomereiter.github.io/sambamba"
SRC_URI="https://github.com/lomereiter/sambamba/archive/v0.6.5.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="debug"

# https://github.com/ldc-developers/gentoo-overlay/tree/master/dev-lang/ldc2
#
# contains bundled htslib
DEPEND=""
RDEPEND="${DEPEND}"

src_compile(){
	if use debug ; then
		emake sambamba-ldmd2-debug
	else
		emake sambamba-ldmd2-64
	fi
}
