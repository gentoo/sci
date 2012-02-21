# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MODULE_AUTHOR="LDS"
inherit perl-module

DESCRIPTION="BigWig and BigBed file perl-based interface for Gbrowse-2"

LICENSE="|| ( Artistic-2 GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-biology/ucsc-genome-browser"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"

SRC_TEST="do"

src_prepare(){
	epatch "${FILESDIR}"/Build.PL.patch || die "Failed to patch Build.PL"
}

CFLAGS="${CFLAGS} -D_REENTRANT -D_GNU_SOURCE -fno-strict-aliasing -pipe -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
