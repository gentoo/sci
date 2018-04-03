# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

INTEL_DIST_SKU=3235
INTEL_DIST_PV=2018_update2_professional_edition
INTEL_SUBDIR=vtune_amplifier

inherit intel-sdp-r1

DESCRIPTION="Intel VTune Amplifier XE"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-vtune-amplifier-xe/"

IUSE="doc"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="~dev-libs/intel-common-18.0.2.199[compiler]"

INTEL_DIST_DAT_RPMS=(
	"vtune-amplifier-2018-cli-common-2018.2-551022.noarch.rpm"
	"vtune-amplifier-2018-common-2018.2-551022.noarch.rpm"
	"vtune-amplifier-2018-common-pset-2018.2-551022.noarch.rpm"
	"vtune-amplifier-2018-gui-common-2018.2-551022.noarch.rpm"
	"vtune-amplifier-2018-sep-2018.2-551022.noarch.rpm"
	"vtune-amplifier-2018-target-2018.2-551022.noarch.rpm")
INTEL_DIST_AMD64_RPMS=(
	"vtune-amplifier-2018-cli-2018.2-551022.x86_64.rpm"
	"vtune-amplifier-2018-collector-64linux-2018.2-551022.x86_64.rpm"
	"vtune-amplifier-2018-gui-2018.2-551022.x86_64.rpm")
INTEL_DIST_X86_RPMS=(
	"vtune-amplifier-2018-cli-32bit-2018.2-551022.i486.rpm"
	"vtune-amplifier-2018-collector-32linux-2018.2-551022.i486.rpm")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=( "vtune-amplifier-2018-doc-2018.2-551022.noarch.rpm" )
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
