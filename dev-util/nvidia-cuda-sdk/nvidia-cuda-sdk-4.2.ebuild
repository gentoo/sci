# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit unpacker toolchain-funcs

DESCRIPTION="NVIDIA CUDA Software Development Kit"
HOMEPAGE="http://developer.nvidia.com/cuda"

CUDA_V=${PV//_/-}
DIR_V=${CUDA_V//./_}
DIR_V=${DIR_V//beta/Beta}

SRC_URI="http://developer.download.nvidia.com/compute/cuda/${DIR_V}/rel/sdk/gpucomputingsdk_${CUDA_V}.9_linux.run"
LICENSE="CUDPP"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +doc +examples opencl +cuda"

RDEPEND=">=dev-util/nvidia-cuda-toolkit-4.2
	examples? ( >=x11-drivers/nvidia-drivers-260.19.21 )
	media-libs/freeglut"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

pkg_setup() {
	if use cuda || use opencl && [[ $(tc-getCXX) == *gcc* ]] && \
		! version_is_at_least "4.5" "$(gcc-version)"; then
		eerror "This package requires >=sys-devel/gcc-4.5 to build sucessfully"
		eerror "Please use gcc-config to switch to a compatible GCC version"
		die ">=sys-devel/gcc-4.4 required"
	fi
	echo $(gcc-major-version) $(gcc-minor-version)
}

src_compile() {
	use examples || return
	local myopts=""
	use debug && myopts+=" dbg=1"
	cd sdk
	use cuda && emake -C C cuda-install="${EPREFIX}"/opt/cuda ${myopts}
	use opencl && emake -C opencl
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
