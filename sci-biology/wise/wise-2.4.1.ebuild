# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs versionator

DESCRIPTION="Genewise, promoterwise: align protein HMMs to DNA for CDS predictions"
HOMEPAGE="http://www.ebi.ac.uk/~birney/wise2"
SRC_URI="http://www.ebi.ac.uk/~birney/${PN}2/${PN}$(delete_version_separator 3).tar.gz"
#SRC_URI="ftp://ftp.ebi.ac.uk/pub/software/${PN}2/${PN}$(delete_version_separator 3).tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND="sci-biology/hmmer:2"
DEPEND="
	${RDEPEND}
	dev-lang/perl
	virtual/latex-base
	dev-libs/glib"

S="${WORKDIR}"/${PN}$(delete_version_separator 3)

src_prepare() {
	epatch "${FILESDIR}"/wise-2.2.0-glibc-2.10.patch
	epatch "${FILESDIR}"/wise-2.4.1-cflags.patch
	epatch "${FILESDIR}"/01_welcome-csh.patch
	epatch "${FILESDIR}"/02_isnumber.patch
	epatch "${FILESDIR}"/03_doc-nodycache.patch
	epatch "${FILESDIR}"/04_wise2-pdflatex-update.patch
	# the two below are already in wise-2.2.0-glibc-2.10.patch wise-2.4.1-cflags.patch
	#epatch "${FILESDIR}"/06_getline.patch
	#epatch "${FILESDIR}"/07_ld--as-needed.patch
	epatch "${FILESDIR}"/08_mayhem.patch
	epatch "${FILESDIR}"/09_dnal-add-return-statement.patch
	epatch "${FILESDIR}"/11_consistent_manual_dates.patch
#	cd "${S}"/docs || die
#	cat "${S}"/src/models/*.tex "${S}"/src/dynlibsrc/*.tex | perl gettex.pl > temp.tex || die
#	cat wise2api.tex temp.tex apiend.tex > api.tex || die
#	epatch "${FILESDIR}"/${PN}-api.tex.patch
	#
	# eventually, zap bundled but modified version of hmmer-2?
	# This is not recommended, because sean and I diverged a while back on indexing
	# strategies. At some point I will need to port the later HMMer into Wise2.
	# rm -rf src/HMMer2 || die "Cannot zap bundled hmmer-2 sources"
	# sed -e "s#HMMER_INCLUDE = ../HMMer2/#HMMER_INCLUDE = ${EPREFIX}/usr/include/hmmer2#" -i src/makefile || die
	# sed -e "s#HMMER_LIBS.* = ../HMMer2/#HMMER_LIBS = ${EPREFIX}/usr/$(get_libdir)"#" -i src/makefile || die
	# TODO: change eventual callers of the hmmer-2 binaries?
	# ./test_data/*.{HMM,hmm}
	# ./src/test/*.{HMM,hmm}
	# ./src/perl/makelib.pl
	#for e in hmmalign hmmbuild hmmcalibrate hmmconvert hmmemit hmmpfam hmmsearch; do \
	#	# append '2' to the filename in "$e"
	#done
}

src_compile() {
	emake \
		-C src \
		CC="$(tc-getCC)" \
		all
	if use doc; then
		cd "${S}"/docs || die
		for i in api appendix dynamite wise2 wise3arch; do
			latex ${i} || die
			latex ${i} || die
			dvips ${i}.dvi -o || die
		done
	fi
}

src_test() {
	cd "${S}"/src || die
	WISECONFIGDIR="${S}/wisecfg" emake test
}

src_install() {
	dobin "${S}"/src/bin/* "${S}"/src/dynlibsrc/testgendb
	use static-libs && \
		dolib.a \
			"${S}"/src/base/libwisebase.a \
			"${S}"/src/dynlibsrc/libdyna.a \
			"${S}"/src/models/libmodel.a

	insinto /usr/share/${PN}
	doins -r "${S}"/wisecfg

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${S}"/docs/*.ps
	fi
	newenvd "${FILESDIR}"/${PN}-env 24wise || die "Failed to install env file"
}
