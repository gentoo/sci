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

DOCS=( AUTHORS NEWS TUTORIAL doc/README )
HTML_DOCS=( doc/{manual.html,style.css} )

src_prepare() {
	# Suppress useless -Wall pollution
	sed -i 's/\-Wall/\-Wno-enum-compare/g' Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCXX)" \
		CFLAGS="" \
		CXXFLAGS="" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS="${CXXFLAGS}"
}

src_install() {
	dobin ${PN} ${PN}-*

	exeinto /usr/libexec/${PN}
	doexe scripts/*

	newman MANUAL ${PN}.1
	einstalldocs

	if use examples; then
		insinto /usr/share/${PN}
		doins -r genomes indexes
	fi
}
