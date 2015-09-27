# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib

X86_AT="AMD-APP-SDK-v${PV}-lnx32.tgz"
AMD64_AT="AMD-APP-SDK-v${PV}-lnx64.tgz"

MY_P_AMD64="AMD-APP-SDK-v${PV}-RC-lnx64"
MY_P_AMD32="AMD-APP-SDK-v${PV}-RC-lnx32"
MY_P="AMD-APP-SDK-v${PV}-RC"

DESCRIPTION="AMD Accelerated Parallel Processing (APP) SDK"
HOMEPAGE="http://developer.amd.com/tools-and-sdks/opencl-zone/amd-accelerated-parallel-processing-app-sdk"
SRC_URI="
	amd64? ( ${AMD64_AT} )
	x86? ( ${X86_AT} )"

LICENSE="AMD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="examples"

RDEPEND="
	app-eselect/eselect-opengl
	!<dev-util/amdstream-2.6
	sys-devel/llvm
	sys-devel/gcc:*
	media-libs/mesa
	media-libs/freeglut
	virtual/opencl
	examples? ( media-libs/glew )
	app-eselect/eselect-opencl"
DEPEND="
	${RDEPEND}
	dev-lang/perl
	dev-util/patchelf
	sys-apps/fakeroot"

RESTRICT="mirror strip fetch"

S="${WORKDIR}/${MY_P}"

pkg_nofetch() {
	einfo "AMD doesn't provide direct download links. Please download"
	einfo "${ARCHIVE} from ${HOMEPAGE}"
}

src_unpack() {
	default

	cd "${WORKDIR}" || die

	if use amd64 || use amd64-linux ; then
		unpack ./${MY_P_AMD64}.tgz
		mv -f "${MY_P_AMD64}" "${MY_P}" || die
	else
		unpack ./${MY_P_X86}.tgz
		mv -f "${MY_P_X86}" "${MY_P}" || die
	fi

	unpack ./icd-registration.tgz
}

src_prepare() {
	AMD_CL=usr/$(get_libdir)/OpenCL/vendors/amd/
}

src_compile() {
	MAKEOPTS+=" -j1"
	use examples && cd samples/opencl && default
}

src_install() {
	dodir /opt/AMDAPP
	cp -R "${S}/"* "${ED}/opt/AMDAPP" || die "Install failed!"

	dodir "${AMD_CL}"
	dosym "/opt/AMDAPP/lib/`arch`/libOpenCL.so"   "${AMD_CL}"
	dosym "/opt/AMDAPP/lib/`arch`/libOpenCL.so.1" "${AMD_CL}"

	insinto /etc/OpenCL/vendors/
	doins ../etc/OpenCL/vendors/*
}
