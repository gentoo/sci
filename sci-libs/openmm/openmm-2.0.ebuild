# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/tatt/tatt-9999.ebuild,v 1.1 2010/07/27 12:36:56 fauli Exp $

EAPI="3"

inherit cmake-utils

MY_PN="${PN^^[om]}"
DESCRIPTION="OpenMM is a library for molecular modeling simulation on GPUs"
HOMEPAGE="https://simtk.org/home/openmm"
SRC_URI="${MY_PN}${PV}-Source.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="+cuda opencl"

RDEPEND=">=dev-util/nvidia-cuda-sdk-3.1
	dev-util/nvidia-cuda-sdk[opencl?,cuda?]"
DEPEND="${RDEPEND}
	dev-util/cmake
	virtual/jre"

RESTRICT="fetch"
DOWNLOAD_URL="https://simtk.org/frs/download.php?file_id=2377"
S="${WORKDIR}/${MY_PN}${PV}-Source/src"

pkg_nofetch(){
	einfo "Please download ${SRC_URI} from:"
	einfo "${DOWNLOAD_URL}"
	einfo "and move/copy to ${DISTDIR}"
}

src_prepare() {
	epatch "${FILESDIR}/${P}-print.patch"
}

src_configure() {
	local mycmakeargs="-DBUILD_TESTING=OFF"

	[ -z "${NVCC_FLAGS}" ] && error "Please add NVCC_FLAGS to '${EROOT}etc/make.conf"

	mycmakeargs="${mycmakeargs}
		-DCUDA_NVCC_FLAGS:STRING=${NVCC_FLAGS}
		$(cmake-utils_use cuda OPENMM_BUILD_CUDA_LIB)
		$(cmake-utils_use opencl OPENMM_BUILD_OPENCL_LIB)"

	addwrite /dev/nvidiactl:/dev/nvidia0

	CUDA_INC_PATH=/opt/cuda \
	cmake-utils_src_configure ${mycmakeargs} \
		|| die "cmake configuration failed"
}

src_install() {
	cmake-utils_src_install
	rm -rf "${ED}"/usr/bin/Test*

	dodoc "${ED}"/usr/docs/*
	rm -rf "${ED}"/usr/docs

	rm -rf "${ED}"/usr/examples/VisualStudio2005
	insinto /usr/share/doc/${PF}/examples
	doins "${ED}"/usr/examples/*

	echo "OPENMM_PLUGIN_DIR=/usr/lib/plugins" > "${T}/80${PN}"
	doenvd "${T}/80${PN}"
}

pkg_postinst() {
	env-update
}

pkg_postrm() {
	env-update
}
