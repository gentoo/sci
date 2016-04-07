# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="C++11 framework for rapid develop and deploy of bioinformatic tasks"
HOMEPAGE="https://sourceforge.net/projects/molbiolib"
SRC_URI="https://sourceforge.net/projects/molbiolib/files/MolBioLib_public.version${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

# contains bundled samtools-0.1.18 and bamtools (pezmaster31-bamtools-d553a62) which contains jsoncpp
# also needs app-doc/doxygen
DEPEND="dev-lang/perl
	sys-devel/gcc:*
	sys-devel/clang
	>=sci-biology/samtools-0.1.18:0
	<sci-biology/samtools-1:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/MolBioLib

src_compile(){
	perl MakeAllApps.pl || die
}

# src_install() needs to be written
