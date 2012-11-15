# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/intel-sdp.eclass,v 1.4 2012/09/20 13:54:56 jlec Exp $

# @ECLASS: intel-sdp.eclass
# @MAINTAINER:
# Sébastien Fabbro <bicatali@gentoo.org>
# Justin Lecher <jlec@gentoo.org>
# Sci Team <sci@gentoo.org>
# @BLURB: Handling of Intel's Software Development Products package management

# @ECLASS-VARIABLE: INTEL_DID
# @DEFAULT_UNSET
# @DESCRIPTION:
# The package download ID from Intel.
# To find out its value, see the links to download in
# https://registrationcenter.intel.com/RegCenter/MyProducts.aspx
#
# e.g. 2504
#
# Must be defined before inheriting the eclass

# @ECLASS-VARIABLE: INTEL_DPN
# @DEFAULT_UNSET
# @DESCRIPTION:
# The package name to download from Intel.
# To find out its value, see the links to download in
# https://registrationcenter.intel.com/RegCenter/MyProducts.aspx
#
# e.g. parallel_studio_xe
#
# Must be defined before inheriting the eclass

# @ECLASS-VARIABLE: INTEL_DPV
# @DEFAULT_UNSET
# @DESCRIPTION:
# The package download version from Intel.
# To find out its value, see the links to download in
# https://registrationcenter.intel.com/RegCenter/MyProducts.aspx
#
# e.g. 2011_sp1_update2
#
# Must be defined before inheriting the eclass

# @ECLASS-VARIABLE: INTEL_SUBDIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# The package sub-directory where it will end-up in /opt/intel
# To find out its value, you have to do a raw install from the Intel tar ball

# @ECLASS-VARIABLE: INTEL_RPMS_DIRS
# @DESCRIPTION:
# List of subdirectories in the main archive which contains the
# rpms to extract.
: ${INTEL_RPMS_DIRS:=rpm}

# @ECLASS-VARIABLE: INTEL_X86
# @DESCRIPTION:
# 32bit arch in rpm names
#
# e.g. i484
: ${INTEL_X86:=i486}

# @ECLASS-VARIABLE: INTEL_BIN_RPMS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Functional name of rpm without any version/arch tag
#
# e.g. compilerprof

# @ECLASS-VARIABLE: INTEL_DAT_RPMS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Functional name of rpm of common data which are arch free
# without any version tag
#
# e.g. openmp

inherit check-reqs multilib versionator

_INTEL_PV1=$(get_version_component_range 1)
_INTEL_PV2=$(get_version_component_range 2)
_INTEL_PV3=$(get_version_component_range 3)
_INTEL_PV4=$(get_version_component_range 4)
_INTEL_URI="http://registrationcenter-download.intel.com/irc_nas/${INTEL_DID}/${INTEL_DPN}"

SRC_URI="
	amd64? ( multilib? ( ${_INTEL_URI}_${INTEL_DPV}.tgz ) )
	amd64? ( !multilib? ( ${_INTEL_URI}_${INTEL_DPV}_intel64.tgz ) )
	x86?  ( ${_INTEL_URI}_${INTEL_DPV}_ia32.tgz )"

LICENSE="Intel-SDP"
# Future work, #394411
#SLOT="${_INTEL_PV1}.${_INTEL_PV2}"
SLOT="0"
IUSE="multilib"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RESTRICT="mirror"

RDEPEND=""
DEPEND=">=app-arch/rpm2targz-9.0.0.3g"

_INTEL_SDP_YEAR=${INTEL_DPV%_update*}
_INTEL_SDP_YEAR=${INTEL_DPV%_sp*}

# @ECLASS-VARIABLE: INTEL_SDP_DIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# Full rootless path to installation dir

INTEL_SDP_DIR="opt/intel/${INTEL_SUBDIR}-${_INTEL_SDP_YEAR:-${_INTEL_PV1}}.${_INTEL_PV3}.${_INTEL_PV4}"

# @ECLASS-VARIABLE: INTEL_SDP_EDIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# Full rooted path to installation dir

INTEL_SDP_EDIR="${EROOT%/}/${INTEL_SDP_DIR}"

S="${WORKDIR}"

QA_PREBUILT="${INTEL_SDP_DIR}/*"

intel-sdp_pkg_pretend() {
	: ${CHECKREQS_DISK_BUILD:=256M}
	check-reqs_pkg_pretend
}

# @ECLASS-VARIABLE: INTEL_ARCH
# @DEFAULT_UNSET
# @DESCRIPTION:
# Intels internal names of the arches; will be set at runtime accordingly
#
# e.g. amd64-multilib -> INTEL_ARCH="intel64 ia32"

intel-sdp_pkg_setup() {
	local arch a p
	if use x86; then
		arch=${INTEL_X86}
		INTEL_ARCH="ia32"
	elif use amd64; then
		arch=x86_64
		INTEL_ARCH="intel64"
		if has_multilib_profile; then
			arch="x86_64 ${INTEL_X86}"
			INTEL_ARCH="intel64 ia32"
		fi
	fi
	INTEL_RPMS=""
	for p in ${INTEL_BIN_RPMS}; do
		for a in ${arch}; do
			INTEL_RPMS="${INTEL_RPMS} intel-${p}-${_INTEL_PV4}-${_INTEL_PV1}.${_INTEL_PV2}-${_INTEL_PV3}.${a}.rpm"
		done
	done
	for p in ${INTEL_DAT_RPMS}; do
		INTEL_RPMS="${INTEL_RPMS} intel-${p}-${_INTEL_PV4}-${_INTEL_PV1}.${_INTEL_PV2}-${_INTEL_PV3}.noarch.rpm"
	done

	case "${EAPI:-0}" in
		0|1|2|3) intel-sdp_pkg_pretend ;;
	esac
}

intel-sdp_src_unpack() {
	local l r t rpmdir
	for t in ${A}; do
		for r in ${INTEL_RPMS}; do
			# Find which subdirectory of the archive the rpm is in
			rpm_found="false"
			for subdir in ${INTEL_RPMS_DIRS}; do
				[[ "${rpm_found}" == "true" ]] && continue
				rpmdir=${t%%.*}/${subdir}
				l=.${r}_$(date +'%d%m%y_%H%M%S').log
				tar xf "${DISTDIR}"/${t} ${rpmdir}/${r} 2> /dev/null || continue
				einfo "Unpacking ${r}"
				rpm_found="true"
				rpm2tar -O "./${rpmdir}/${r}" | tar xvf - | sed -e \
					"s:^\.:${EROOT#/}:g" > ${l} || die "unpacking ${r} failed"
				mv ${l} opt/intel/ || die "failed moving extract log file"
			done
		done
	done
	mv -v opt/intel/* ${INTEL_SDP_DIR} || die "mv to INTEL_SDP_DIR failed"
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


# @ECLASS-VARIABLE: INTEL_SDP_DB
# @DESCRIPTION:
# Full path to intel registry db
INTEL_SDP_DB="${EROOT%/}"/opt/intel/intel-sdp-products.db

intel-sdp_pkg_postinst() {
	elog "Make sure you have recieved the an Intel license."
	elog "To receive a non-commercial license, you need to register at:"
	elog "http://software.intel.com/en-us/articles/non-commercial-software-development/"
	elog "Install the license file into ${EROOT}opt/intel/licenses."

	# add product registry to intel "database"
	local l r
	for r in ${INTEL_RPMS}; do
		l="$(ls -1 ${EROOT%/}/opt/intel/.${r}_*.log | head -n 1)"
		echo >> ${INTEL_SDP_DB} \
			"<:${r%-${_INTEL_PV4}*}-${_INTEL_PV4}:${r}:${INTEL_SDP_EDIR}:${l}:>"
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
case "${EAPI:-0}" in
	0|1|2|3) ;;
	4) EXPORT_FUNCTIONS pkg_pretend ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac
