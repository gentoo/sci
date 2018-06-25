# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="GCLib - Genomic C(++) library of reusable code for bioinformatics projects"
HOMEPAGE="https://github.com/gpertea/gclib"
SRC_URI="https://github.com/gpertea/gclib/archive/v0.10.2.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/Makefile.patch )

src_install(){
	dobin gtest threads
	dodoc README.md
	insinto /usr/include/"${PN}"
	doins *.h *.hh
}
