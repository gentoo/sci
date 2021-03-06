# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Popular short read aligner for Next-generation sequencing data"
HOMEPAGE="http://bowtie-bio.sourceforge.net/bowtie2/"
SRC_URI="https://github.com/BenLangmead/${PN}2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"

IUSE="examples cpu_flags_x86_sse2 +tbb" # sra
# IUSE=sra Use sra-toolkit to download input datasets on the fly.

RDEPEND="dev-lang/perl
	tbb? ( dev-cpp/tbb )"
DEPEND="${RDEPEND}
	app-arch/unzip
	sys-libs/readline"
#	sra? ( sci-biology/sra_sdk )"

S="${WORKDIR}/${PN}2-${PV}"

DOCS=( AUTHORS NEWS TUTORIAL )
HTML_DOCS=( doc/{manual.html,style.css} )

pkg_pretend() {
	if ! use cpu_flags_x86_sse2 ; then
		eerror "This package requires a CPU supporting the SSE2 instruction set."
		die "SSE2 support missing"
	fi
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCXX)" \
		CXX="$(tc-getCXX)" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS="${CXXFLAGS} -msse2" \
		WITH_TBB="$(usex tbb 1 0)"
		# USE_SRA="$(usex sra 1 0)"
}

src_install() {
	dobin ${PN}2 ${PN}2-*

	exeinto /usr/libexec/${PN}2
	doexe scripts/*

	newman MANUAL ${PN}2.1
	einstalldocs

	if use examples; then
		insinto /usr/share/${PN}2
		doins -r example
	fi
}
