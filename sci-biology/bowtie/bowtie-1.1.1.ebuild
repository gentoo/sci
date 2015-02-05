# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base eutils toolchain-funcs

DESCRIPTION="An ultrafast memory-efficient short read aligner"
HOMEPAGE="http://bowtie-bio.sourceforge.net/"
SRC_URI="mirror://sourceforge/bowtie-bio/bowtie-1.1.1-src.zip"

LICENSE="Artistic"
SLOT="1"
IUSE=""
KEYWORDS="~amd64 ~x86 ~x64-macos"

DEPEND="app-arch/unzip"
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-buildsystem.patch )

src_compile() {
	unset CFLAGS
	emake \
		CXX="$(tc-getCXX)" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS="${CXXFLAGS}"
}

src_install() {
	dobin bowtie bowtie-*
	exeinto /usr/share/${PN}/scripts
	doexe scripts/*

	insinto /usr/share/${PN}
	doins -r genomes indexes

	newman MANUAL bowtie.1
	dodoc AUTHORS NEWS TUTORIAL doc/README
	dohtml doc/{manual.html,style.css}
}
