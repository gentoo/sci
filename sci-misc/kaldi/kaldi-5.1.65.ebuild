# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs cuda flag-o-matic

COMMIT_ID="9e06caa1fb0306898632c6fa3ad67571c4d06cf5"
DESCRIPTION="A toolkit for speech recognition"
HOMEPAGE="http://kaldi-asr.org/"
SRC_URI="https://github.com/kaldi-asr/kaldi/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda doc double-precision speex test"
REQUIRED_USE="double-precision? ( !speex )"

RDEPEND="
	>=sci-misc/openfst-1.6.0
	virtual/cblas
	virtual/lapack
	virtual/lapacke
	cuda? ( dev-util/nvidia-cuda-toolkit )
	speex? ( media-libs/speex )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${PN}-${COMMIT_ID}/src

PATCHES=(
	"${FILESDIR}"/Makefile.0d5e4b1.patch
	"${FILESDIR}"/default_rules.mk.96eec2b.patch
)

# We need write acccess /dev/nvidiactl, /dev/nvidia0 and /dev/nvidia-uvm and the portage
# user is (usually) not in the video group
RESTRICT="cuda? ( userpriv )"

pkg_pretend() {
	local cblas_provider=$(eselect cblas show)

	if [[ ! ${cblas_provider} =~ (atlas|openblas) ]]; then
		die "Build with '${cblas_provider}' CBLAS is not supported"
	fi
}

src_prepare() {
	default
	use cuda && cuda_src_prepare
}

src_configure() {
	cat <<-EOF > base/version.h
		#define KALDI_VERSION "${PV}-${COMMIT_ID:0:5}"
		#define KALDI_GIT_HEAD "${COMMIT_ID}"
	EOF

	echo "true" > base/get_version.sh

	append-cxxflags \
		$($(tc-getPKG_CONFIG) --cflags cblas) \
		$($(tc-getPKG_CONFIG) --cflags lapack)

	append-libs \
		$($(tc-getPKG_CONFIG) --libs cblas) \
		$($(tc-getPKG_CONFIG) --libs lapack)

	use test || append-cppflags -DNDEBUG

	if use speex; then
		append-cppflags -DHAVE_SPEEX
		append-libs -lspeex
	fi

	cat <<-EOF > kaldi.mk
		KALDI_FLAVOR := dynamic
		KALDILIBDIR := "${S}"/lib
		CXX = $(tc-getCXX)
		AR = $(tc-getAR)
		AS = $(tc-getAS)
		RANLIB = $(tc-getRANLIB)
		DOUBLE_PRECISION = $(usex double-precision 1 0)
		OPENFSTINC = "."
		OPENFSTLIBS = -lfst
	EOF

	local cblas_provider=$(eselect cblas show)

	if [[ ${cblas_provider} =~ atlas ]]; then
		cat <<-EOF >> kaldi.mk
			ATLASINC = "."
			ATLASLIBS = -L.
		EOF

		cat makefiles/linux_atlas.mk >> kaldi.mk
	elif [[ ${cblas_provider} =~ openblas ]]; then
		append-cxxflags $($(tc-getPKG_CONFIG) --cflags lapacke)

		cat <<-EOF >> kaldi.mk
			OPENBLASINC = "."
			OPENBLASLIBS = -L.
		EOF

		cat makefiles/linux_openblas.mk >> kaldi.mk
	fi

	cat <<-EOF >> kaldi.mk
		CXXFLAGS += ${CXXFLAGS}
		LDLIBS += ${LIBS}
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
