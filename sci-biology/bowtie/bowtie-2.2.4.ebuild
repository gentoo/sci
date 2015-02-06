# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="An ultrafast memory-efficient short read aligner"
HOMEPAGE="http://bowtie-bio.sourceforge.net/bowtie2/"
SRC_URI="mirror://sourceforge/project/${PN}-bio/${PN}2/${PV}/${PN}2-${PV}-source.zip"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"

IUSE="examples cpu_flags_x86_sse2"
REQUIRED_USE="cpu_flags_x86_sse2"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
		app-arch/unzip"

S="${WORKDIR}/${PN}2-${PV}"

PATCHES=( "${FILESDIR}"/${P}-buildsystem.patch )

src_prepare() {
	epatch ${PATCHES[@]}
}

src_compile() {
	unset CFLAGS
	emake \
		CXX="$(tc-getCXX)" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS="${CXXFLAGS} -msse2"
}

src_install() {
	dobin ${PN}2 ${PN}2-*

	exeinto /usr/libexec/${PN}2
	doexe scripts/*

	newman MANUAL ${PN}2.2
	dodoc AUTHORS NEWS TUTORIAL
	docinto html
	dodoc doc/{manual.html,style.css}

	if use examples; then
		insinto /usr/share/${PN}2
		doins -r example
	fi
}
