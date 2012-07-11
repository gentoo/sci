# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit unpacker toolchain-funcs versionator

DESCRIPTION="NVIDIA CUDA Software Development Kit"
HOMEPAGE="http://developer.nvidia.com/cuda"

MYD=$(get_version_component_range 1)_$(get_version_component_range 2)

SRC_URI="http://developer.download.nvidia.com/compute/cuda/${MYD}/rel/sdk/gpucomputingsdk_${PV}_linux.run"
LICENSE="CUDPP"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +doc +examples opencl +cuda"

RDEPEND=">=dev-util/nvidia-cuda-toolkit-${PV}
	examples? ( >=x11-drivers/nvidia-drivers-260.19.21 )
	media-libs/freeglut"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

pkg_setup() {
	if use cuda || use opencl && [[ $(tc-getCXX) == *gcc* ]] && \
		! version_is_at_least 4.5 "$(gcc-version)"; then
		eerror "This package requires >=sys-devel/gcc-4.5 to build sucessfully"
		eerror "Please use gcc-config to switch to a compatible GCC version"
		die ">=sys-devel/gcc-4.4 required"
	fi
}

src_compile() {
	use examples || return
	local myopts=""
	use debug && myopts+=" dbg=1"
	cd sdk
	use cuda && emake -C C cuda-install="${EPREFIX}"/opt/cuda ${myopts}
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
