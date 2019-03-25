# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C++11 framework for bioinformatics tasks"
HOMEPAGE="https://sourceforge.net/projects/molbiolib"
SRC_URI="https://sourceforge.net/projects/molbiolib/files/MolBioLib_public.version${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="" # does not build
IUSE="doc"

# contains bundled samtools-0.1.18 and bamtools (pezmaster31-bamtools-d553a62)
# which contains jsoncpp, also needs app-doc/doxygen
DEPEND="
	dev-lang/perl
	sys-devel/gcc:*
	sys-devel/clang:*
	>=sci-biology/samtools-0.1.18:0.1-legacy
	<sci-biology/samtools-1:0.1-legacy"
RDEPEND="${DEPEND}"
CDEPEND="doc? ( app-doc/doxygen )"

S="${WORKDIR}"/MolBioLib

src_prepare(){
	# edit MakeAllApps.pl
	default
}

src_compile(){
	perl MakeAllApps.pl || die
}

src_install(){
	# TODO: install the app somehow
	use doc && dodoc -r docs/doxygen/*
}
