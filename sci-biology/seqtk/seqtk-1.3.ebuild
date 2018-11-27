# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Manipulate FASTA and FASTQ files"
HOMEPAGE="https://github.com/lh3/seqtk"
SRC_URI="https://github.com/lh3/seqtk/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
PATCHES="${FILESDIR}"/"${P}"_Makefile.patch

src_install(){
	emake install BINDIR="${ED}/usr/bin"
}
