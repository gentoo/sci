# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Popular short read aligner for Next-generation sequencing data"
HOMEPAGE="http://bowtie-bio.sourceforge.net/"
SRC_URI="https://github.com/BenLangmead/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic"
SLOT="1"
KEYWORDS="~amd64 ~x86"

IUSE="examples +tbb"

RDEPEND="tbb? ( dev-cpp/tbb )"
DEPEND="${RDEPEND}
	app-arch/unzip"
#	sci-biology/seqan:1.4"

DOCS=( AUTHORS NEWS TUTORIAL doc/README )
HTML_DOCS=( doc/{manual.html,style.css} )

src_prepare() {
	default

	# remove bundled library of headers, use system seqan 1.4
	# rm -rf SeqAn-1.1/ third_party/ || die

	# innocuous non-security flags, prevent log pollution
	append-cxxflags \
		-Wno-unused-local-typedefs \
		-Wno-unused-but-set-variable \
		-Wno-unused-variable
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCXX)" \
		CFLAGS="" \
		CXXFLAGS="" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS="${CXXFLAGS}" \
		WITH_TBB="$(usex tbb 1 0)"
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
