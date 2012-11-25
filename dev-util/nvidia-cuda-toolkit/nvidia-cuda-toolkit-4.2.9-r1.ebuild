# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cuda unpacker

MYD=$(get_version_component_range 1)_$(get_version_component_range 2)
DISTRO=ubuntu11.04

DESCRIPTION="NVIDIA CUDA Toolkit (compiler and friends)"
HOMEPAGE="http://developer.nvidia.com/cuda"
CURI="http://developer.download.nvidia.com/compute/cuda/${MYD}/rel/toolkit"
SRC_URI="
	amd64? ( ${CURI}/cudatoolkit_${PV}_linux_64_${DISTRO}.run )
	x86? ( ${CURI}/cudatoolkit_${PV}_linux_32_${DISTRO}.run )"

SLOT="0"
LICENSE="NVIDIA"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debugger doc eclipse profiler"

DEPEND=""
RDEPEND="${DEPEND}
	|| (
		sys-devel/gcc:4.4
		sys-devel/gcc:4.5
		sys-devel/gcc:4.6
		)
	!<=x11-drivers/nvidia-drivers-270.41
	debugger? ( sys-libs/libtermcap-compat )
	profiler? ( >=virtual/jre-1.6 )"

S="${WORKDIR}"

QA_PREBUILT="opt/cuda/*"

pkg_setup() {
	# We don't like to run cuda_pkg_setup as it depends on us
	:
}

src_prepare() {
	local cuda_supported_gcc

	cuda_supported_gcc="4.4 4.5 4.6"

	sed \
		-e "s:CUDA_SUPPORTED_GCC:${cuda_supported_gcc}:g" \
		"${FILESDIR}"/cuda-config.in > "${T}"/cuda-config || die

	find cuda-installer.pl install-linux.pl libnvvp/jre run_files -delete || die
}

src_install() {
	local cudadir=/opt/cuda
	local ecudadir="${EPREFIX}"${cudadir}

	if use doc; then
		dodoc doc/*{txt,pdf}
		dohtml -r doc/html/*
	fi

	find doc -delete || die

	use debugger || rm -r bin/cuda-gdb extras/Debugger
	use eclipse || find libnsight -delete

	if use profiler; then
		# hack found in install-linux.pl
		cat > bin/nvvp <<- EOF
			#!${EPREFIX}bin/sh
			LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${ecudadir}/lib:${ecudadir}/lib64 \
				UBUNTU_MENUPROXY=0 LIBOVERLAY_SCROLLBAR=0 ${ecudadir}/libnvvp/nvvp
		EOF
		chmod a+x bin/nvvp
	else
		rm -r extras/CUPTI libnvvp
	fi

	dodir ${cudadir}
	mv * "${ED}"${cudadir}

	cat > "${T}"/99cuda <<- EOF
		PATH=${ecudadir}/bin:${ecudadir}/libnvvp
		ROOTPATH=${ecudadir}/bin
		LDPATH=${ecudadir}/lib$(use amd64 && echo "64:${ecudadir}/lib")
	EOF
	doenvd "${T}"/99cuda

	dobin "${T}"/cuda-config
}

pkg_postinst() {
	local a
	a="$(version_sort $(cuda-config -s))"; a=($a)
	if [[ $(tc-getCC) == *gcc* ]] && \
		version_is_at_least "$(gcc-version)" ${a[1]}; then
			ewarn "gcc >= ${a[1]} will not work with CUDA"
			ewarn "Make sure you set an earlier version of gcc with gcc-config"
			ewarn "or append --compiler-bindir= pointing to a gcc bindir like"
			ewarn "${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/gcc${a[1]}"
			ewarn "to the nvcc compiler flags"
	fi
}
