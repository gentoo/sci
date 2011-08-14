# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: intel-sdp.eclass
# @MAINTAINER: bicatali@gentoo.org
# @BLURB: simplify Intel Software Development Products package management

# @ECLASS-VARIABLE: INTEL_DPV
# @DEFAULT_UNSET
# @DESCRIPTION: the package download version from Intel. It must be defined.
# To find out its value, see the links to download in
# https://registrationcenter.intel.com/RegCenter/MyProducts.aspx

# @ECLASS-VARIABLE: INTEL_DID
# @DEFAULT_UNSET
# @DESCRIPTION: the package download ID from Intel. It must be defined.
# To find out its value, see the links to download in
# https://registrationcenter.intel.com/RegCenter/MyProducts.aspx

# @ECLASS-VARIABLE: INTEL_DPN
# @DEFAULT_UNSET
# @DESCRIPTION: the package name to download from Intel. It must be defined.
# To find out its value, see the links to download in
# https://registrationcenter.intel.com/RegCenter/MyProducts.aspx

# @ECLASS-VARIABLE: INTEL_SUBDIR
# @DEFAULT_UNSET
# @DESCRIPTION: the package sub-directory where it will end-up in /opt/intel
# To find out its value, you have to do a raw install from the Intel tar ball

inherit versionator check-reqs multilib

INTEL_PV1=$(get_version_component_range 1)
INTEL_PV2=$(get_version_component_range 2)
INTEL_PV3=$(get_version_component_range 3)
INTEL_PV4=$(get_version_component_range 4)
INTEL_URI="http://registrationcenter-download.intel.com/irc_nas/${INTEL_DID}/${INTEL_DPN}"

SRC_URI="amd64? ( multilib? ( ${INTEL_URI}_${INTEL_DPV}.tgz ) )
	amd64? ( !multilib? ( ${INTEL_URI}_${INTEL_DPV}_intel64.tgz ) )
	x86?  ( ${INTEL_URI}_${INTEL_DPV}_ia32.tgz )"

LICENSE="Intel-SDP"
SLOT="${INTEL_PV1}.${INTEL_PV2}"
IUSE="multilib"
KEYWORDS="-* ~amd64 ~x86"

RESTRICT="mirror"

RDEPEND=""
DEPEND=">=app-arch/rpm2targz-9.0.0.3g"
INTEL_SDP_YEAR=${INTEL_DPV%_update*}
INTEL_SDP_DIR="opt/intel/${INTEL_SUBDIR}-${INTEL_SDP_YEAR:-${INTEL_PV1}}.${INTEL_PV3}.${INTEL_PV4}"
INTEL_SDP_EDIR="${EROOT%/}/${INTEL_SDP_DIR}"

S="${WORKDIR}"

intel-sdp_pkg_setup() {
	local arch a p
	if use x86; then
		arch=${INTEL_X86:-i486}
		INTEL_ARCH="ia32"
	elif use amd64; then
		arch=x86_64
		INTEL_ARCH="intel64"
		if has_multilib_profile; then
			arch="x86_64 ${INTEL_X86:-i486}"
			INTEL_ARCH="intel64 ia32"
		fi
	fi
	INTEL_RPMS=""
	for p in ${INTEL_BIN_RPMS}; do
		for a in ${arch}; do
			INTEL_RPMS="${INTEL_RPMS} intel-${p}-${INTEL_PV4}-${INTEL_PV1}.${INTEL_PV2}-${INTEL_PV3}.${a}.rpm"
		done
	done
	for p in ${INTEL_DAT_RPMS}; do
		INTEL_RPMS="${INTEL_RPMS} intel-${p}-${INTEL_PV4}-${INTEL_PV1}.${INTEL_PV2}-${INTEL_PV3}.noarch.rpm"
	done
	[[ -z ${CHECKREQS_DISK_BUILD} ]] && CHECKREQS_DISK_BUILD=256
	check_reqs
}

intel-sdp_src_unpack() {
	local l r t rpmdir
	for t in ${A}; do
		# TODO: need to find a fast way to find the rpmdir
		# in some cases rpms are in rpms/, in other cases in rpm/
		# tar tvf is too slow for 1.4G tar balls
		rpmdir=${t%.tgz}/rpm
		for r in ${INTEL_RPMS}; do
			einfo "Unpacking ${r}"
			l=.${r}_$(date +'%d%m%y_%H%M%S').log
			tar xf "${DISTDIR}"/${t} \
				${rpmdir}/${r} || die "extracting ${r} failed"
			rpm2tar -O "./${rpmdir}/${r}" | tar xvf - \
				| sed -e "s:^\.:${EROOT#/}:g" > ${l} || die "failure unpacking ${r}"
			mv ${l} opt/intel/ || die "failed moving extract log file"
		done
	done
}

intel_link_eclipse_plugins() {
	pushd ${INTEL_SDP_DIR}/eclipse_support > /dev/null
	local c f
	for c in cdt*; do
		local cv=${c#cdt} ev=3.$(( ${cv:0:1} - 1))
		if has_version "dev-util/eclipse-sdk:${ev}"; then
			einfo "Linking eclipse (v${ev}) plugin cdt (v${cv})"
			for f in cdt${cv}/eclipse/features/*; do
				dodir /usr/$(get_libdir)/eclipse-${ev}/features
				dosym "${INTEL_SDP_EDIR}"/eclipse_support/${f} \
					/usr/$(get_libdir)/eclipse-${ev}/features/ || die
			done
			for f in cdt${cv}/eclipse/plugins/*; do
				dodir /usr/$(get_libdir)/eclipse-${ev}/plugins
				dosym "${INTEL_SDP_EDIR}"/eclipse_support/${f} \
					/usr/$(get_libdir)/eclipse-${ev}/plugins/ || die
			done
		fi
	done
	popd > /dev/null
}

intel-sdp_src_install() {
	[[ -d ${INTEL_SDP_DIR}/eclipse_support ]] && \
		has eclipse ${IUSE} && \
		use eclipse && \
		intel_link_eclipse_plugins
	einfo "Tagging ${PN}"
	find opt -name \*sh -type f -exec sed -i \
		-e "s:<.*DIR>:${INTEL_SDP_EDIR}:g" \
		'{}' \;
	mkdir -p "${ED:-${D}}"/ || die
	mv opt "${ED:-${D}}"/ || die "moving files failed"
}

intel-sdp_pkg_postinst() {
	# add product registry to intel "database"
	local l r
	INTEL_SDP_DB="${EROOT%/}"/opt/intel/intel-sdp-products.db
	for r in ${INTEL_RPMS}; do
		l="$(ls -1 ${EROOT%/}/opt/intel/.${r}_*.log | head -n 1)"
		echo >> ${INTEL_SDP_DB} \
			"<:${r%-${INTEL_PV4}*}-${INTEL_PV4}:${r}:${INTEL_SDP_EDIR}:${l}:>"
	done
}

intel-sdp_pkg_postrm() {
	# remove from intel "database"
	if [[ -e ${INTEL_SDP_DB} ]]; then
		local r
		for r in ${INTEL_RPMS}; do
			sed -i \
				-e "/${r}/d" \
				${INTEL_SDP_DB}
		done
	fi
}

EXPORT_FUNCTIONS pkg_setup src_unpack src_install pkg_postinst pkg_postrm
