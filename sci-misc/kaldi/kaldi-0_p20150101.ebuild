# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils flag-o-matic subversion

DESCRIPTION="A toolkit for speech recognition"
HOMEPAGE="http://kaldi.sourceforge.net/"
ESVN_REPO_URI="https://svn.code.sf.net/p/kaldi/code/trunk/src@4735"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc test threads"
KEYWORDS=""

RDEPEND="
	media-libs/speex
	sci-libs/atlas[lapack,threads=]
	~sci-misc/openfst-1.3.4"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch \
		"${FILESDIR}"/configure.patch \
		"${FILESDIR}"/Makefile.patch \
		"${FILESDIR}"/default_rules.mk.patch
}

src_configure() {
	# Upstream's configure script is "hand-generated" and not autotools compatible,
	# for this reason econf can not be used
	./configure \
		--shared \
		--fst-root="${EPREFIX}/usr" \
		$(use threads && echo --threaded-atlas=yes) \
		--atlas-root="${EPREFIX}/usr/include/atlas" || die "failed to run configure"

	use test || append-cxxflags -DNDEBUG

	sed -i \
		-e 's/OPENFST_VER =/OPENFST_VER = 1.3.4#/' \
		-e "s:-g :-DHAVE_SPEEX ${CXXFLAGS} :" \
		-e "s:-lm -lpthread -ldl:-lm -lpthread -ldl -lspeex ${LDFLAGS}:" \
		kaldi.mk || die "sed unix/kaldi.mk failed"
}

src_compile() {
	emake
	use doc && doxygen
}

src_install() {
	dolib.so $(make print-libfiles)
	dobin $(make print-binfiles)
	use doc && dohtml -r html/*
}
