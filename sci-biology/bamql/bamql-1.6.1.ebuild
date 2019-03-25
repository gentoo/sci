# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils

DESCRIPTION="Extract reads from BAM files"
HOMEPAGE="https://github.com/BoutrosLaboratory/bamql
	https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-016-1162-y"
SRC_URI="https://github.com/BoutrosLaboratory/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

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

src_configure(){
	local mycmakeargs=()
	use static-libs && mycmakeargs+=( "--enable-static=yes" "--enable-static-llvm=yes" ) || \
		mycmakeargs+=( "--enable-static=no" "--enable-static-llvm=no" )
	econf ${mycmakeargs[@]}
}
