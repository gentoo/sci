# Copyright 2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit rpm multilib

DESCRIPTION="Intel's implementation of the OpenCL standard"
HOMEPAGE="http://software.intel.com/en-us/articles/opencl-sdk/"
SRC_URI="http://registrationcenter.intel.com/irc_nas/3142/\
intel_sdk_for_ocl_applications_2013_xe_sdk_${PV}_x64.tgz"

LICENSE="Intel-SDP"
SLOT="0"
IUSE="mic"
KEYWORDS="~amd64"

RDEPEND="app-admin/eselect-opencl
		sys-process/numactl"

RESTRICT="mirror strip"

QA_EXECSTACK="
	/opt/intel/opencl-1.2-${PV}/bin/KernelBuilder64.bin
"
QA_PREBUILT="
	/opt/intel/opencl-1.2-${PV}/bin/KernelBuilder64.bin
	/opt/intel/opencl-1.2-${PV}/bin/ioc64.bin
	/opt/intel/opencl-1.2-${PV}/lib64/libcl_logger.so
	/opt/intel/opencl-1.2-${PV}/lib64/libclang_compiler.so
	/opt/intel/opencl-1.2-${PV}/lib64/libintelocl.so
	/opt/intel/opencl-1.2-${PV}/lib64/libOpenCL.so.1.2
	/opt/intel/opencl-1.2-${PV}/lib64/libtask_executor.so
	/opt/intel/opencl-1.2-${PV}/lib64/libcpu_device.so
"

S="${WORKDIR}/intel_sdk_for_ocl_applications_2013_xe_sdk_${PV}_x64"

src_unpack() {
	default
	cd "${S}"
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
	doins -r etc
	doins -r opt

	dodir "${INTEL_CL}"
	dosym "/opt/intel/opencl-1.2-${PV}/lib64/libOpenCL.so"     "${INTEL_CL}"
	dosym "/opt/intel/opencl-1.2-${PV}/lib64/libOpenCL.so.1"   "${INTEL_CL}"
	dosym "/opt/intel/opencl-1.2-${PV}/lib64/libOpenCL.so.1.2" "${INTEL_CL}"

	dodir "/etc/OpenCL/vendors"
	dosym "/opt/intel/opencl-1.2-${PV}/etc/intel64.icd" /etc/OpenCL/vendors
}
