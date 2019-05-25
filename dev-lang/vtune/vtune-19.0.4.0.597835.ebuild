# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

INTEL_DIST_PV=2019_update4_professional_edition
INTEL_SUBDIR=vtune_amplifier

inherit intel-sdp-r1

DESCRIPTION="Intel VTune Amplifier XE"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-vtune-amplifier-xe/"

IUSE="doc"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="~dev-libs/intel-common-19.0.4.243[compiler]"

INTEL_DIST_DAT_RPMS=(
	"vtune-amplifier-2019-cli-common-2019.4-597835.noarch.rpm"
	"vtune-amplifier-2019-common-2019.4-597835.noarch.rpm"
	"vtune-amplifier-2019-common-pset-2019.4-597835.noarch.rpm"
	"vtune-amplifier-2019-gui-common-2019.4-597835.noarch.rpm"
	"vtune-amplifier-2019-sep-2019.4-597835.noarch.rpm"
	"vtune-amplifier-2019-target-2019.4-597835.noarch.rpm")
INTEL_DIST_AMD64_RPMS=(
	"vtune-amplifier-2019-cli-2019.4-597835.x86_64.rpm"
	"vtune-amplifier-2019-collector-64linux-2019.4-597835.x86_64.rpm"
	"vtune-amplifier-2019-gui-2019.4-597835.x86_64.rpm")
INTEL_DIST_X86_RPMS=(
	"vtune-amplifier-2019-cli-32bit-2019.4-597835.i486.rpm"
	"vtune-amplifier-2019-collector-32linux-2019.4-597835.i486.rpm")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=( "vtune-amplifier-2019-doc-2019.4-597835.noarch.rpm" )
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
