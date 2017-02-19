# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="Parallell process SAM/BAM/CRAM files faster than samtools"
HOMEPAGE="http://lomereiter.github.io/sambamba"
EGIT_REPO_URI="https://github.com/lomereiter/sambamba.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=""
RDEPEND="${DEPEND}"

src_compile(){
	if use debug ; then
		emake sambamba-ldmd2-debug
	else
		emake sambamba-ldmd2-64
	fi
}
