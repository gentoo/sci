# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="An ultrafast memory-efficient short read aligner"
HOMEPAGE="http://bowtie-bio.sourceforge.net/"
SRC_URI="mirror://sourceforge/bowtie-bio/${P}-src.zip"

LICENSE="Artistic"
SLOT="1"
KEYWORDS="~amd64 ~x86 ~x64-macos"

IUSE="examples"

DEPEND="app-arch/unzip"
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-buildsystem.patch )

src_prepare() {
	epatch ${PATCHES[@]}
}

src_compile() {
	unset CFLAGS
	emake \
		CXX="$(tc-getCXX)" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS="${CXXFLAGS}"
}

src_install() {
	dobin ${PN} ${PN}-*

	exeinto /usr/libexec/${PN}
	doexe scripts/*

	newman MANUAL ${PN}
	dodoc AUTHORS NEWS TUTORIAL doc/README
	docinto html
	dodoc doc/{manual.html,style.css}

	if use examples; then
		insinto /usr/share/${PN}
		doins -r genomes indexes
	fi
}
