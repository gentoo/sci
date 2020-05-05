# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

INTEL_DIST_PV=2020_update1_professional_edition
INTEL_SUBDIR=vtune_profiler

inherit intel-sdp-r1

DESCRIPTION="Intel VTune Profiler"
HOMEPAGE="https://software.intel.com/en-us/vtune"

IUSE="doc"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="~dev-libs/intel-common-19.1.1.217[compiler]"

MY_PV="$(ver_rs 3 '-')" # 20.1.0-607630

QA_PREBUILT="*"

INTEL_DIST_DAT_RPMS=(
	"vtune-profiler-2020-cli-common-${MY_PV}.noarch.rpm"
	"vtune-profiler-2020-common-${MY_PV}.noarch.rpm"
	"vtune-profiler-2020-common-pset-${MY_PV}.noarch.rpm"
	"vtune-profiler-2020-sep-${MY_PV}.noarch.rpm"
	"vtune-profiler-2020-target-${MY_PV}.noarch.rpm")
INTEL_DIST_AMD64_RPMS=(
	"vtune-profiler-2020-cli-${MY_PV}.x86_64.rpm"
	"vtune-profiler-2020-collector-64linux-${MY_PV}.x86_64.rpm"
	"vtune-profiler-2020-gui-${MY_PV}.x86_64.rpm"
	"vtune-profiler-2020-vpp-server-${MY_PV}.x86_64.rpm")
INTEL_DIST_X86_RPMS=(
	"vtune-profiler-2020-cli-32bit-${MY_PV}.i486.rpm"
	"vtune-profiler-2020-collector-32linux-${MY_PV}.i486.rpm")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=( "vtune-profiler-2020-doc-${MY_PV}.noarch.rpm" )
	fi
}

src_install() {
	intel-sdp-r1_src_install

	local path="PATH="
	use abi_x86_64 && path+=":$(isdp_get-sdp-edir)/bin64"
	use abi_x86_32 && path+=":$(isdp_get-sdp-edir)/bin32"
	echo "${path}" > "${T}"/35vtune || die
	doenvd "${T}"/35vtune
}
