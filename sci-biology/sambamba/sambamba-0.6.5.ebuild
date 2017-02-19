# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Parallell process SAM/BAM/CRAM files faster than samtools"
HOMEPAGE="http://lomereiter.github.io/sambamba"
SRC_URI="https://github.com/lomereiter/sambamba/archive/v0.6.5.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="debug"

# needs ldmd2 compiler from LDC package
# wget https://github.com/ldc-developers/ldc/releases/download/v0.17.1/ldc2-0.17.1-linux-x86_64.tar.xz
# tar xJf ldc2-0.17.1-linux-x86_64.tar.xz
# export PATH=~/ldc2-0.17.1-linux-x86_64/bin/:$PATH
# export LIBRARY_PATH=~/ldc2-0.17.1-linux-x86_64/lib/
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
