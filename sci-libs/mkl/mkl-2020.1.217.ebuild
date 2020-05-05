# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

INTEL_DIST_PV=2020_update1_professional_edition

inherit intel-sdp-r1 numeric-int64-multibuild

DESCRIPTION="Intel Math Kernel Library: linear algebra, fft, math functions"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-mkl/"

IUSE="doc int64"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND=""
RDEPEND="~dev-libs/intel-common-19.1.1.217[compiler]"

CHECKREQS_DISK_BUILD=3500M

MY_PV="$(ver_rs 2 '-')" # 2020.1-217

QA_PREBUILT="*"

INTEL_DIST_DAT_RPMS=(
	"mkl-cluster-c-${MY_PV}-${MY_PV}.noarch.rpm"
	"mkl-cluster-f-${MY_PV}-${MY_PV}.noarch.rpm"
	"mkl-common-${MY_PV}-${MY_PV}.noarch.rpm"
	"mkl-common-c-${MY_PV}-${MY_PV}.noarch.rpm"
	"mkl-common-c-ps-${MY_PV}-${MY_PV}.noarch.rpm"
	"mkl-common-f-${MY_PV}-${MY_PV}.noarch.rpm"
	"mkl-common-ps-${MY_PV}-${MY_PV}.noarch.rpm"
	"mkl-f95-common-${MY_PV}-${MY_PV}.noarch.rpm")
INTEL_DIST_AMD64_RPMS=(
	"mkl-cluster-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-cluster-rt-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-core-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-core-c-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-core-f-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-core-ps-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-core-rt-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-f95-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-gnu-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-gnu-c-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-gnu-f-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-gnu-f-rt-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-gnu-rt-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-pgi-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-pgi-c-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-pgi-rt-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-tbb-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-tbb-rt-${MY_PV}-${MY_PV}.x86_64.rpm")
INTEL_DIST_X86_RPMS=(
	"mkl-core-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-core-c-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-core-f-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-core-ps-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-core-rt-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-f95-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-gnu-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-gnu-c-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-gnu-f-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-gnu-f-rt-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-gnu-rt-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-tbb-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"mkl-tbb-rt-32bit-${MY_PV}-${MY_PV}.x86_64.rpm")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=(
			"mkl-doc-2020-${MY_PV}.noarch.rpm"
			"mkl-doc-ps-2020-${MY_PV}.noarch.rpm")
	fi
}

_mkl_add_alternative_provider() {
	local prov=$1; shift
	local alt
	for alt in $*; do
		NUMERIC_MODULE_NAME=${prov} \
			numeric-int64-multibuild_install_alternative ${alt} ${prov}
	done
}

src_install() {
	intel-sdp-r1_src_install

	sed -i -e "s#<INSTALLDIR>#$(isdp_get-sdp-edir)/linux#" \
		"${ED}"/opt/intel/compilers_and_libraries_2020.1.217/linux/mkl/bin/pkgconfig/* \
		|| die "sed failed"

	mkdir -p "${ED}"/usr/$(get_libdir)/pkgconfig/ || die "mkdir failed"
	cp "${ED}"/opt/intel/compilers_and_libraries_2020.1.217/linux/mkl/bin/pkgconfig/* \
		"${ED}"/usr/$(get_libdir)/pkgconfig/ || die "cp failed"

	local ldpath="LDPATH="
	use abi_x86_64 && ldpath+=":$(isdp_get-sdp-edir)/linux/mkl/lib/$(isdp_convert2intel-arch abi_x86_64)"
	use abi_x86_32 && ldpath+=":$(isdp_get-sdp-edir)/linux/mkl/lib/$(isdp_convert2intel-arch abi_x86_32)"
	echo "${ldpath}" > "${T}"/35mkl || die
	doenvd "${T}"/35mkl
}
