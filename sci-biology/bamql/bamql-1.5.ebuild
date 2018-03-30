# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Extract reads from BAM files"
HOMEPAGE="https://github.com/BoutrosLaboratory/bamql
	https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-016-1162-y"
SRC_URI="https://github.com/BoutrosLaboratory/bamql/archive/v1.5.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	sys-devel/llvm:=
	sys-apps/util-linux
	sci-libs/htslib
	dev-libs/libpcre"
RDEPEND="${DEPEND}"

src_prepare(){
	eautoreconf
	default
}
