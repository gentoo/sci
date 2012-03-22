# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/gatk/gatk-9999.ebuild,v 1.1 2011/10/31 21:18:17 weaver Exp $

EAPI=4

MY_HASH=885c33a

EGIT_REPO_URI="https://github.com/PacificBiosciences/blasr.git"

inherit git

DESCRIPTION="The PacBio long read aligner"
HOMEPAGE="http://www.smrtcommunity.com/SMRT-Analysis/Algorithms/BLASR"
#SRC_URI="https://github.com/PacificBiosciences/blasr/tarball/${PV} -> ${P}.tar.gz"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
IUSE=""
KEYWORDS=""

DEPEND="sci-libs/hdf5[cxx]"
RDEPEND=""

S="${WORKDIR}/blasr-${MY_HASH}"

ASSEMBLY_HOME="${D}/usr"

src_install() {
	dodir /usr/bin
	make install ASSEMBLY_HOME="${D}/usr" || die
}
