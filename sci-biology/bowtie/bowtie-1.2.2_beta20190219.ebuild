# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs git-r3

DESCRIPTION="Popular short read aligner for Next-generation sequencing data"
HOMEPAGE="http://bowtie-bio.sourceforge.net/"
EGIT_REPO_URI="https://github.com/BenLangmead/bowtie.git"
EGIT_BRANCH="bug_fixes"
COMMIT="f253e204f5ba4565d14ae1b300ea6cb10dfe4660"

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

PATCHES=( "${FILESDIR}/bowtie-1.2.2-fix-isa-return-type.patch" )
# not needed
# "${FILESDIR}/${P}-fix-Intel-compilation.patch", obsoleted by https://github.com/BenLangmead/bowtie/commit/d8b661fb36c129cb9899fcd3689b3618036f8c7b
#
# still to be considered
#PATCHES=(
#	"${FILESDIR}/${P}-_ContextLss-1.1-1.4.patch"
#	"${FILESDIR}/${P}-unbundle-seqan.patch"
#	"${FILESDIR}/${P}-fix-setBegin-call.patch"
#	"${FILESDIR}/${P}-seqan-popcount.patch"
#	"${FILESDIR}/${P}-seqan-rename-ChunkPool.patch"
#	"${FILESDIR}/${P}-seqan-rename-fill-to-resize.patch"
#	"${FILESDIR}/${P}-spelling.patch"
#	"${FILESDIR}/${P}-tbb-tinythread-missing.patch"
#)

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
