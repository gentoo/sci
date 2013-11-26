# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="An ultrafast memory-efficient short read aligner"
HOMEPAGE="http://bowtie-bio.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}-bio/${PN}2/${PV}/${PN}2-${PV}-source.zip"

LICENSE="GPL-3"
SLOT="2"
IUSE="examples"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
		app-arch/unzip"

S="${WORKDIR}/${PN}2-${PV}"

pkg_pretend() {
	grep "sse2" /proc/cpuinfo > /dev/null
	if [[ $? -ne 0 ]] ; then
		ewarn "Your processor does not support sse2. Bowtie will probably not work on this machine."
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${P}-buildsystem.patch"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCXX)" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS="${CXXFLAGS} -msse2"
}

src_install() {
	dobin ${PN}2 ${PN}2-*
	exeinto /usr/share/${PN}2/scripts
	doexe scripts/*

	newman MANUAL ${PN}2.1
	dodoc AUTHORS NEWS TUTORIAL
	dohtml doc/manual.html doc/style.css

	if use examples; then
		insinto /usr/share/${PN}2
		doins -r example
	fi
}
