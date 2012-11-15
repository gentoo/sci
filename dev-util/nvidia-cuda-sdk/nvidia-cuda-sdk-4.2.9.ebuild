# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cuda eutils unpacker toolchain-funcs versionator

MYD=$(get_version_component_range 1)_$(get_version_component_range 2)
DESCRIPTION="NVIDIA CUDA Software Development Kit"
HOMEPAGE="http://developer.nvidia.com/cuda"
SRC_URI="http://developer.download.nvidia.com/compute/cuda/${MYD}/rel/sdk/gpucomputingsdk_${PV}_linux.run"

LICENSE="CUDPP"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +doc +examples opencl +cuda"

RDEPEND="
	>=dev-util/nvidia-cuda-toolkit-${PV}
	media-libs/freeglut
	examples? (
			>=x11-drivers/nvidia-drivers-296
			media-libs/glew
		)"
DEPEND="${RDEPEND}"

S=${WORKDIR}

gcc_supported_installed() {
	local gcc_bindir _ver
	for _ver in $*; do
		has_version sys-devel/gcc:${_ver} && \
			gcc_bindir="$(ls -d ${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/${_ver}* | tail -n 1)" && \
			break
	done
	if [[ -n ${gcc_bindir} ]]; then
		echo "${gcc_bindir}"
		return 0
	else
		eerror "Only gcc version(s) $* are supported"
		die "Only gcc version(s) $* are supported"
		return 1
	fi
}

src_prepare() {
	local nvcc_bindir

	if use cuda || use opencl && [[ $(tc-getCXX) == *g++* ]]; then
		nvcc_bindir="--compiler-bindir=\"$(gcc_supported_installed 4.6 4.5 4.4)\""
	fi

	epatch "${FILESDIR}"/${P}-asneeded.patch

	sed \
		-e "/LINK/s:gcc:$(tc-getCC) ${LDFLAGS}:g" \
		-e "/LINK/s:g++:$(tc-getCXX) ${LDFLAGS}:g" \
		-e "/CC/s:gcc:$(tc-getCC):g" \
		-e "/CX/s:g++:$(tc-getCXX):g" \
		-e "/NVCCFLAGS/s|\(:=\)|\1 ${nvcc_bindir} |g" \
		-e 's:-Wimplicit::g' \
		-e 's:-O2::g' \
		-e 's:GLEW_x86_64:GLEW:g' \
		-i $(find sdk -type f -name "*.mk") || die

	find sdk/shared/inc/GL -delete || die
	find sdk -type f -name "*\.a" -delete || die
}

src_compile() {
	use examples || return
	local myopts="verbose=1"
	use debug && myopts+=" dbg=1"
	cd sdk
	use cuda && emake -C C cuda-install="${EPREFIX}/opt/cuda" ${myopts}
	use opencl && emake -C OpenCL
}

src_install() {
	cd sdk
	use doc || rm -rf *.txt doc */doc */Samples.htm */releaseNotesData
	use examples || rm -rf bin */bin */tools
	local f
	for f in $(find .); do
		local t="$(dirname ${f})"
		if [[ ${t/obj\/} != ${t} || ${t##*.} == a ]]; then
			continue
		fi
		if [[ ! -d ${f} ]]; then
			if [[ -x ${f} ]]; then
				exeinto /opt/cuda/sdk/${t}
				doexe ${f}
			else
				insinto /opt/cuda/sdk/${t}
				doins ${f}
			fi
		fi
	done
}
