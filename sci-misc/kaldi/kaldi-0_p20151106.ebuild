# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs cuda flag-o-matic

DESCRIPTION="A toolkit for speech recognition"
HOMEPAGE="http://kaldi-asr.org/"
SRC_URI="http://gentoo.akreal.net/distfiles/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc test cuda"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/speex
	virtual/cblas
	virtual/lapack
	virtual/lapacke
	>=sci-misc/openfst-1.4.1
	cuda? ( dev-util/nvidia-cuda-toolkit )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

# We need write acccess /dev/nvidiactl, /dev/nvidia0 and /dev/nvidia-uvm and the portage
# user is (usually) not in the video group
RESTRICT="test? ( cuda? ( userpriv ) )"

pkg_pretend() {
	local cblas_provider=$(eselect cblas show)

	if [[ ! ${cblas_provider} =~ (atlas|mkl|openblas) ]]; then
		die "Build with '${cblas_provider}' CBLAS is not supported"
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/Makefile.patch \
		"${FILESDIR}"/default_rules.mk.a7d9824.patch
}

src_configure() {
	append-cxxflags \
		-DKALDI_DOUBLEPRECISION=0 \
		-DHAVE_POSIX_MEMALIGN \
		-DHAVE_EXECINFO_H=1 \
		-DHAVE_CXXABI_H \
		-DHAVE_SPEEX \
		-DHAVE_OPENFST_GE_10400 \
		-std=c++0x \
		-Wall \
		-I.. \
		-pthread \
		-Wno-sign-compare \
		-Wno-unused-local-typedefs \
		-Winit-self \
		-rdynamic \
		-fPIC \
		$($(tc-getPKG_CONFIG) --cflags cblas) \
		$($(tc-getPKG_CONFIG) --cflags lapack)

	append-libs \
		-lspeex \
		-lfst \
		-lm \
		-lpthread \
		-ldl \
		$($(tc-getPKG_CONFIG) --libs cblas) \
		$($(tc-getPKG_CONFIG) --libs lapack)

	local cblas_provider=$(eselect cblas show)

	if [[ ${cblas_provider} =~ atlas ]]; then
		append-cxxflags -DHAVE_ATLAS
	elif [[ ${cblas_provider} =~ mkl ]]; then
		append-cxxflags -DHAVE_MKL
	elif [[ ${cblas_provider} =~ openblas ]]; then
		append-cxxflags -DHAVE_OPENBLAS $($(tc-getPKG_CONFIG) --cflags lapacke)
	fi

	use test || append-cxxflags -DNDEBUG

	cat <<-EOF > kaldi.mk
		KALDI_FLAVOR := dynamic
		KALDILIBDIR := "${S}"/lib
		CC = $(tc-getCXX)
		RANLIB = $(tc-getRANLIB)
		LDLIBS = ${LIBS}
	EOF

	if use cuda; then
		cat <<-EOF >> kaldi.mk
			CUDA = true
			CUDATKDIR = "${EPREFIX}"/opt/cuda
		EOF
		cat makefiles/linux_x86_64_cuda.mk >> kaldi.mk
		sed -i \
			-e "s:CUDA_FLAGS = -g:CUDA_FLAGS = ${NVCCFLAGS}:" \
			kaldi.mk || die "sed unix/kaldi.mk failed"
	fi
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
	use doc && dodoc -r html
}
