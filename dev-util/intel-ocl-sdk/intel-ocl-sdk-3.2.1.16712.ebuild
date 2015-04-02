# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit rpm multilib

DESCRIPTION="Intel's implementation of the OpenCL standard"
HOMEPAGE="http://software.intel.com/en-us/articles/opencl-sdk/"
SRC_URI="http://registrationcenter.intel.com/irc_nas/3809/\
intel_sdk_for_ocl_applications_xe_2013_r3_sdk_${PV}_x64.tgz"

LICENSE="Intel-SDP"
SLOT="0"
IUSE="mic"
KEYWORDS="~amd64"

RDEPEND="app-eselect/eselect-opencl
		sys-process/numactl"

RESTRICT="mirror strip"

QA_PREBUILT="opt/*"

S="${WORKDIR}/intel_sdk_for_ocl_applications_xe_2013_r3_sdk_${PV}_x64"

src_unpack() {
	default
	cd "${S}" || die
	rpm_unpack "./opencl-1.2-base-${PV}-1.x86_64.rpm"
	rpm_unpack "./opencl-1.2-devel-${PV}-1.x86_64.rpm"
	rpm_unpack "./opencl-1.2-intel-cpu-${PV}-1.x86_64.rpm"
	rpm_unpack "./opencl-1.2-intel-devel-${PV}-1.x86_64.rpm"
	use mic && rpm_unpack "./opencl-1.2-intel-mic-${PV}-1.x86_64.rpm"
}

src_prepare() {
	INTEL_CL=usr/$(get_libdir)/OpenCL/vendors/intel/
}

src_install() {
	insinto /
	doins -r etc
	doins -r opt
	fperms 0755 "/opt/intel/opencl-1.2-${PV}/bin/ioc64"
	fperms 0755 "/opt/intel/opencl-1.2-${PV}/bin/ioc64.bin"
	fperms 0755 "/opt/intel/opencl-1.2-${PV}/bin/KernelBuilder64"
	fperms 0755 "/opt/intel/opencl-1.2-${PV}/bin/KernelBuilder64.bin"
	fperms 0755 "/opt/intel/opencl-1.2-${PV}/lib64/llc"
	fperms 0755 "/opt/intel/opencl-1.2-${PV}/lib64/llvm-dis"

	dodir "${INTEL_CL}"
	dosym "/opt/intel/opencl-1.2-${PV}/lib64/libOpenCL.so"     "${INTEL_CL}/libOpenCL.so"
	dosym "/opt/intel/opencl-1.2-${PV}/lib64/libOpenCL.so.1"   "${INTEL_CL}/libOpenCL.so.1"
	dosym "/opt/intel/opencl-1.2-${PV}/lib64/libOpenCL.so.1.2" "${INTEL_CL}libOpenCL.so.1.2"

	dodir "/etc/OpenCL/vendors"
	dosym "/opt/intel/opencl-1.2-${PV}/etc/intel64.icd" "/etc/OpenCL/vendors/intel64.icd"
}
