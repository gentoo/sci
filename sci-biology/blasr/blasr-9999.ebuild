# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_HASH=885c33a

inherit git-r3

DESCRIPTION="The PacBio long read aligner"
HOMEPAGE="http://www.smrtcommunity.com/SMRT-Analysis/Algorithms/BLASR"
#SRC_URI="https://github.com/PacificBiosciences/blasr/tarball/${PV} -> ${P}.tar.gz"
SRC_URI=""
EGIT_REPO_URI="https://github.com/PacificBiosciences/blasr.git"

LICENSE="blasr"
SLOT="0"
IUSE=""
KEYWORDS=""

DEPEND="sci-libs/hdf5[cxx]"
RDEPEND=""

S="${WORKDIR}/blasr-${MY_HASH}"

src_install() {
	dodir /usr/bin
	emake install ASSEMBLY_HOME="${ED}/usr"
}
