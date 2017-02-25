# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs cuda flag-o-matic

COMMIT_ID="16e69f1aacce8ad0665d2b6666c053b1421a9e91"
DESCRIPTION="A toolkit for speech recognition"
HOMEPAGE="http://kaldi-asr.org/"
SRC_URI="https://github.com/kaldi-asr/kaldi/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

S=${WORKDIR}/${PN}-${COMMIT_ID}/src

LICENSE="Apache-2.0"
SLOT="0"
IUSE="cuda doc speex test"
KEYWORDS="~amd64"

RDEPEND="
	speex? ( media-libs/speex )
	virtual/cblas
	virtual/lapack
	virtual/lapacke
	<sci-misc/openfst-1.5.0
	cuda? ( dev-util/nvidia-cuda-toolkit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

# We need write acccess /dev/nvidiactl, /dev/nvidia0 and /dev/nvidia-uvm and the portage
# user is (usually) not in the video group
RESTRICT="cuda? ( userpriv )"

pkg_pretend() {
	local cblas_provider=$(eselect cblas show)

	if [[ ! ${cblas_provider} =~ (atlas|mkl|openblas) ]]; then
		die "Build with '${cblas_provider}' CBLAS is not supported"
	fi
}

src_prepare() {
	eapply \
		"${FILESDIR}"/Makefile.patch \
		"${FILESDIR}"/default_rules.mk.a7d9824.patch
	eapply_user

	use cuda && cuda_src_prepare
}

src_configure() {
	append-cxxflags \
		-DHAVE_EXECINFO_H=1 \
		-DHAVE_CXXABI_H \
		-DHAVE_OPENFST_GE_10400 \
		-std=c++11 \
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

	if use speex; then
		append-cxxflags -DHAVE_SPEEX
		append-libs -lspeex
	fi

	cat <<-EOF > kaldi.mk
		KALDI_FLAVOR := dynamic
		KALDILIBDIR := "${S}"/lib
		CC = $(tc-getCXX)
		RANLIB = $(tc-getRANLIB)
		LDLIBS = ${LIBS}
		DOUBLE_PRECISION = 0
	EOF

	if use cuda; then
		cat <<-EOF >> kaldi.mk
			CUDA = true
			CUDATKDIR = "${EPREFIX}"/opt/cuda
			CUDA_ARCH :=
			CUDA_ARCH +=
		EOF
		cat makefiles/cuda_64bit.mk >> kaldi.mk
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
