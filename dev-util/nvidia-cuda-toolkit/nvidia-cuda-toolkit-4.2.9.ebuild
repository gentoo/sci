# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils unpacker versionator toolchain-funcs

DESCRIPTION="NVIDIA CUDA Toolkit"
HOMEPAGE="http://developer.nvidia.com/cuda"

MYD=$(get_version_component_range 1)_$(get_version_component_range 2)
DISTRO=ubuntu11.04

CURI="http://developer.download.nvidia.com/compute/cuda/${MYD}/rel/toolkit"
SRC_URI="
	amd64? ( ${CURI}/cudatoolkit_${PV}_linux_64_${DISTRO}.run )
	x86? ( ${CURI}/cudatoolkit_${PV}_linux_32_${DISTRO}.run )"

LICENSE="NVIDIA"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debugger doc profiler"

DEPEND=""
RDEPEND="${DEPEND}
	!<=x11-drivers/nvidia-drivers-270.41
	debugger? ( sys-libs/libtermcap-compat )
	profiler? ( >=virtual/jre-1.6 )"

S="${WORKDIR}"

QA_PREBUILT="
	opt/cuda/*"

src_install() {
	local cudadir=/opt/cuda
	local prefix="${EPREFIX}"${cudadir}
	rm install-linux.pl
	# use system jre
	rm -r libnvvp/jre
	use doc || rm -r doc
	use debugger || rm -r bin/cuda-gdb extras/Debugger
	if use profiler; then
		# hack found in install-linux.pl
		cat > bin/nvvp <<-EOF
			#!${EPREFIX}bin/sh
			LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${prefix}/lib:${prefix}/lib64 UBUNTU_MENUPROXY=0 LIBOVERLAY_SCROLLBAR=0 ${prefix}/libnvvp/nvvp
		EOF
		chmod a+x bin/nvvp
	else
		rm -r extras/CUPTI libnvvp
	fi

	dodir ${cudadir}
	mv * "${ED}"${cudadir}

	cat > "${T}"/99cuda <<- EOF
		PATH=${prefix}/bin:${prefix}/libnvvp
		ROOTPATH=${prefix}/bin
		LDPATH=${prefix}/lib$(use amd64 && echo "64:${prefix}/lib")
		MANPATH=${prefix}/man
	EOF
	doenvd "${T}"/99cuda
}

pkg_postinst() {
	if [[ $(tc-getCC) == *gcc* ]] && version_is_at_least 4.7 "$(gcc-version)"
	then
		ewarn "gcc >= 4.7 will not work with CUDA"
		ewarn "Make sure you set an earlier version of gcc with gcc-config"
	fi
}
