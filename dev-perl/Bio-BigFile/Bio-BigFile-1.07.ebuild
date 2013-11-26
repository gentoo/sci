# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR="LDS"

inherit eutils flag-o-matic perl-module

DESCRIPTION="BigWig and BigBed file perl-based interface for Gbrowse-2"

LICENSE="|| ( Artistic-2 GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/IO-String
	sci-biology/bioperl
	sci-biology/ucsc-genome-browser[static-libs]"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"

SRC_TEST="do"

src_prepare(){
	append-cflags -D_REENTRANT -D_GNU_SOURCE -fno-strict-aliasing
	append-lfs-flags
	epatch "${FILESDIR}"/Build.PL.patch
}
