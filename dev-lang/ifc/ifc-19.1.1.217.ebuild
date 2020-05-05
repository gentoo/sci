# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

INTEL_DIST_PV=2020_update1_professional_edition

inherit intel-sdp-r1

DESCRIPTION="Intel FORTRAN Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="doc"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="~dev-libs/intel-common-${PV}[compiler]"

MY_PV="$(ver_rs 3 '-')" # 20.1.0-607630

QA_PREBUILT="*"

CHECKREQS_DISK_BUILD=400M

INTEL_DIST_DAT_RPMS=( "ifort-common-${MY_PV}-${MY_PV}.noarch.rpm" )
INTEL_DIST_AMD64_RPMS=( "ifort-${MY_PV}-${MY_PV}.x86_64.rpm" )
INTEL_DIST_X86_RPMS=( "ifort-32bit-${MY_PV}-${MY_PV}.x86_64.rpm" )

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=( "ifort-doc-19.1-${MY_PV}.noarch.rpm" )
	fi
}

src_install() {
	# already provided in dev-libs/intel-common
	rm \
		"${WORKDIR}"/opt/intel/compilers_and_libraries_2020.1.217/linux/compiler/include/omp_lib.f90 \
		"${WORKDIR}"/opt/intel/compilers_and_libraries_2020.1.217/linux/compiler/include/intel64/omp_lib.mod \
		"${WORKDIR}"/opt/intel/compilers_and_libraries_2020.1.217/linux/compiler/include/intel64/omp_lib_kinds.mod \
		|| die "rm failed"

	intel-sdp-r1_src_install
}
