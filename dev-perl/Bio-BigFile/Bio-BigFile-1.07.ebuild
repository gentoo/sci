# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="LDS"

inherit flag-o-matic perl-module

DESCRIPTION="BigWig and BigBed file perl-based interface for Gbrowse-2"

LICENSE="|| ( Artistic-2 GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/IO-String
	sci-biology/bioperl
	sci-biology/ucsc-genome-browser[static-libs]"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST="do"

PATCHES=(
	"${FILESDIR}"/Build.PL.patch
)

src_prepare(){
	append-cflags -D_REENTRANT -D_GNU_SOURCE -fno-strict-aliasing
	append-lfs-flags
	default
}
