# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic

DESCRIPTION="A toolkit for speech recognition"
HOMEPAGE="http://kaldi-asr.org/"
SRC_URI="http://gentoo.akreal.net/distfiles/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc test threads -atlas cuda"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/speex
	virtual/lapack
	virtual/lapacke
	>=sci-misc/openfst-1.4.1
	atlas? ( sci-libs/atlas[threads=] )
	!atlas? ( sci-libs/openblas[-openmp,-threads] sci-libs/lapack-reference )
	cuda? ( dev-util/nvidia-cuda-toolkit )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

REQUIRED_USE="!atlas? ( !threads )"

# We need write acccess /dev/nvidiactl, /dev/nvidia0 and /dev/nvidia-uvm and the portage
# user is (usually) not in the video group
RESTRICT="test? ( cuda? ( userpriv ) )"

src_prepare() {
	epatch \
		"${FILESDIR}"/configure.patch \
		"${FILESDIR}"/Makefile.patch \
		"${FILESDIR}"/default_rules.mk.a7d9824.patch
}

src_configure() {
	if use atlas; then
		myconf+=( --atlas-root="${EPREFIX}/usr/include/atlas" )
		if use threads; then
			myconf+=( --threaded-atlas=yes )
		fi
	else
		myconf+=( --openblas-root="${EPREFIX}/usr" )
		append-cxxflags "-I${EPREFIX}/usr/include/openblas"
		append-libs -lreflapack
	fi

	# Upstream's configure script is "hand-generated" and not autotools compatible,
	# for this reason econf can not be used
	./configure \
		--shared \
		--fst-root="${EPREFIX}/usr" \
		$(use cuda && echo "--use-cuda=yes --cudatk-dir=${EPREFIX}/opt/cuda" \
			|| echo --use-cuda=no) \
		"${myconf[@]}" || die "failed to run configure"

	use test || append-cxxflags -DNDEBUG
	append-libs -lspeex

	sed -i \
		-e "s:-g # -O0 -DKALDI_PARANOID:-DHAVE_SPEEX ${CXXFLAGS} :" \
		-e "s:-lm -lpthread -ldl:-lm -lpthread -ldl ${LIBS} ${LDFLAGS}:" \
		-e "s:CUDA_FLAGS = -g:CUDA_FLAGS = -O2:" \
		kaldi.mk || die "sed unix/kaldi.mk failed"
}

src_compile() {
	default
	use doc && doxygen
}

src_test() {
	if use cuda; then
		addwrite /dev/nvidiactl
		addwrite /dev/nvidia0
		addwrite /dev/nvidia-uvm
	fi
	default
}

src_install() {
	dolib.so $(make print-libfiles)
	dobin $(make print-binfiles)
	use doc && dohtml -r html/*
}
