# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils git-r3 toolchain-funcs

DESCRIPTION="A general purpose GPU library."
HOMEPAGE="http://www.arrayfire.com/"
EGIT_REPO_URI="https://github.com/arrayfire/arrayfire.git"
KEYWORDS="~amd64"

LICENSE="ArrayFire"
SLOT="0"
IUSE="+examples +cpu cuda"

RDEPEND="
	>=sys-devel/gcc-4.7.3-r1
	virtual/blas
	virtual/cblas
	cuda? ( >=dev-util/nvidia-cuda-toolkit-6.0 )
	sci-libs/fftw:3.0"
DEPEND="${RDEPEND}"

# We need write acccess /dev/nvidiactl, /dev/nvidia0 and /dev/nvidia-uvm and the portage
# user is (usually) not in the video group
if use cuda; then
	RESTRICT="userpriv"
fi

S="${WORKDIR}/${P}"

QA_PREBUILT="/usr/share/arrayfire/examples/helloworld_cpu
	/usr/share/arrayfire/examples/pi_cpu
	/usr/share/arrayfire/examples/vectorize_cpu
	/usr/share/arrayfire/examples/helloworld_cuda
	/usr/share/arrayfire/examples/pi_cuda
	/usr/share/arrayfire/examples/vectorize_cuda"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	if use cpu; then
		epatch "${FILESDIR}/FindCBLAS.patch"
	fi
	cmake-utils_src_prepare
}

src_configure() {
	if use cuda; then
		addwrite /dev/nvidiactl
		addwrite /dev/nvidia0
		addwrite /dev/nvidia-uvm
	fi

	local mycmakeargs="
	-DCMAKE_BUILD_TYPE=Release
	$(cmake-utils_use_build cpu CPU)
	$(cmake-utils_use_build cuda CUDA)
	-DBUILD_OPENCL=OFF
	$(cmake-utils_use_build examples EXAMPLES)
	-DBUILD_TEST=OFF
	"

	BUILD_DIR="${S}/build" cmake-utils_src_configure
}

src_compile() {
	BUILD_DIR="${S}/build" cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	exeinto /usr/bin
	doexe "build/bin2cpp"

	if use examples; then
		ebegin "Installing examples"
			exeinto /usr/share/arrayfire/examples/
			if use cpu; then
				doexe "build/examples/helloworld_cpu"
				doexe "build/examples/pi_cpu"
				doexe "build/examples/vectorize_cpu"
			fi
			if use cuda; then
				doexe "build/examples/helloworld_cuda"
				doexe "build/examples/pi_cuda"
				doexe "build/examples/vectorize_cuda"
			fi
		eend
	fi
}