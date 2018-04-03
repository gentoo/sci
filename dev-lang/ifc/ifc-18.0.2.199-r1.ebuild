# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

INTEL_DIST_SKU=3235
INTEL_DIST_PV=2018_update2_professional_edition

inherit intel-sdp-r1

DESCRIPTION="Intel FORTRAN Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="doc"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="~dev-libs/intel-common-${PV}[compiler]"

CHECKREQS_DISK_BUILD=400M

INTEL_DIST_DAT_RPMS=( "ifort-common-18.0.2-199-18.0.2-199.noarch.rpm" )
INTEL_DIST_X86_RPMS=( "ifort-32bit-18.0.2-199-18.0.2-199.x86_64.rpm" )
INTEL_DIST_AMD64_RPMS=( "ifort-18.0.2-199-18.0.2-199.x86_64.rpm" )

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=( "ifort-doc-18.0-18.0.2-199.noarch.rpm" )
	fi
}

src_install() {
	# already provided in dev-libs/intel-common
	rm \
		"${WORKDIR}"/opt/intel/compilers_and_libraries_2018.2.199/linux/compiler/include/omp_lib.f90 \
		"${WORKDIR}"/opt/intel/compilers_and_libraries_2018.2.199/linux/compiler/include/intel64/omp_lib.mod \
		"${WORKDIR}"/opt/intel/compilers_and_libraries_2018.2.199/linux/compiler/include/intel64/omp_lib_kinds.mod \
		|| die "rm failed"

	intel-sdp-r1_src_install
}
