# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="An ultrafast memory-efficient short read aligner"
HOMEPAGE="http://bowtie-bio.sourceforge.net/"
SRC_URI="mirror://sourceforge/bowtie-bio/${P}-source.zip"

LICENSE="GPL-3"
SLOT="2"
IUSE="sse2 examples"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-lang/perl"
DEPEND="${CDEPEND} \
		app-arch/unzip"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${PN}2-${PV}"

pkg_pretend() {
	if ! use sse2 ; then
		ebegin
		eerror "bowtie2 requires sse2 support. Please make sure your system supports"
		eerror "sse2 and enable the sse2 use flag."
		eend
		die
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${P}-buildsystem.patch"
}

src_compile() {
	use sse2 && append-cxxflags -msse2
	emake \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCXX)" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS="${CXXFLAGS}"
}

src_install() {
	dobin bowtie2 bowtie2-*
	exeinto /usr/share/${PN}2/scripts
	doexe scripts/*

	newman MANUAL bowtie2.1
	dodoc AUTHORS NEWS TUTORIAL
	dohtml doc/manual.html doc/style.css

	if use examples; then
		insinto /usr/share/${PN}2
		doins -r example
	fi
}
