# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib

X86_AT="AMD-APP-SDK-v${PV}-lnx32.tgz"
AMD64_AT="AMD-APP-SDK-v${PV}-lnx64.tgz"

MY_P="AMD-APP-SDK-v2.8-RC-lnx64"

DESCRIPTION="AMD Accelerated Parallel Processing (APP) SDK"
HOMEPAGE="http://developer.amd.com/tools/heterogeneous-computing/\
amd-accelerated-parallel-processing-app-sdk"
SRC_URI="
		amd64? ( ${AMD64_AT} )
		x86? ( ${X86_AT} )"
LICENSE="AMD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="examples"

RDEPEND="
	app-admin/eselect-opengl
	!<dev-util/amdstream-2.6
	sys-devel/llvm
	sys-devel/gcc
	media-libs/mesa
	media-libs/freeglut
	virtual/opencl
	examples? ( media-libs/glew )
	app-admin/eselect-opencl"
DEPEND="
	${RDEPEND}
	dev-lang/perl
	dev-util/patchelf
	sys-apps/fakeroot"

RESTRICT="mirror strip"

S="${WORKDIR}/${MY_P}"

pkg_nofetch() {
	einfo "AMD doesn't provide direct download links. Please download"
	einfo "${ARCHIVE} from ${HOMEPAGE}"
}

src_unpack() {
	default
	unpack ./${MY_P}.tgz
	unpack ./icd-registration.tgz
}

src_prepare() {
	AMD_CL=usr/$(get_libdir)/OpenCL/vendors/amd/
}

src_compile() {
	MAKEOPTS+=" -j1"
	use examples && cd samples/opencl && emake
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
