# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/intel-sdp.eclass,v 1.4 2012/09/20 13:54:56 jlec Exp $

# @ECLASS: intel-sdp.eclass
# @MAINTAINER:
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

# @ECLASS-VARIABLE: INTEL_SDP_DB
# @DESCRIPTION:
# Full path to intel registry db
INTEL_SDP_DB="${EROOT%/}"/opt/intel/intel-sdp-products.db

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
IUSE="examples multilib static-libs"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RESTRICT="mirror"

RDEPEND=""
DEPEND="app-arch/rpm2targz"

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

# @ECLASS-FUNCTION: intel_link_eclipse_plugins
# @DESCRIPTION:
# Creating necessary links to use intel compiler with eclipse
intel_link_eclipse_plugins() {
    local c f
    pushd ${INTEL_SDP_DIR}/eclipse_support > /dev/null
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

# @ECLASS-FUNCTION: big-warning
# @INTERNAL
# warn user that we really require a license
big-warning() {
    case ${1} in
        test-failed )
            echo
            ewarn "Function test failed. Most probably due to an invalid license."
            ewarn "This means you already tried to bypass the license check once."
            ;;
    esac

    echo ""
    ewarn "Make sure you have recieved the an Intel license."
    ewarn "To receive a non-commercial license, you need to register at:"
    ewarn "http://software.intel.com/en-us/articles/non-commercial-software-development/"
    ewarn "Install the license file into ${INTEL_SDP_EDIR}/licenses/"

    case ${1} in
        pre-check )
            ewarn "before proceeding with installation of ${P}"
            echo ""
            ;;
        * )
            echo ""
            ;;
            esac
}

# @ECLASS-FUNCTION: _version_test
# @INTERNAL
# Testing for valid license by asking for version information of the compiler
_version-test() {
    local _comp _comp_full _arch _file _warn
    case ${PN} in
        ifc )
            debug-print "Testing ifort"
            _comp=ifort
            ;;
        icc )
            debug-print "Testing icc"
            _comp=icc
            ;;
        *)
            die "${PN} is not supported for testing"
            ;;
    esac

    for _arch in ${INTEL_ARCH}; do
        case ${EBUILD_PHASE} in
            install )
                _comp_full="${ED}/${INTEL_SDP_DIR}/bin/${_arch}/${_comp}"
                ;;
            postinst )
                _comp_full="${INTEL_SDP_EDIR}/bin/${_arch}/${_comp}"
                ;;
            * )
                ewarn "Compile test not supported in ${EBUILD_PHASE}"
                continue
                ;;
        esac

        debug-print "LD_LIBRARY_PATH=\"${INTEL_SDP_EDIR}/bin/${_arch}/\" \"${_comp_full}\" -V"

        LD_LIBRARY_PATH="${INTEL_SDP_EDIR}/bin/${_arch}/" "${_comp_full}" -V &>/dev/null
        [[ $? -ne 0 ]] && _warn=yes
    done
    [[ "${_warn}" == "yes" ]] && big-warning test-failed
}

# @ECLASS-FUNCTION: run-test
# @INTERNAL
# Test if installed compiler is working
run-test() {
    case ${PN} in
        ifc | icc )
            _version_test ;;
        * )
            debug-print "No test available for ${PN}"
            ;;
    esac
}

# @ ECLASS-FUNCTION: intel-sdp_pkg_setup
# @DESCRIPTION:
# The setup finction serves two purposes:
#
# * Check that the user has a (valid) license file before going on.
#
# * Setting up and sorting some internal variables
intel-sdp_pkg_setup() {
	local _warn=1 _dirs i _ret arch a p
	_dirs=(
		"${INTEL_SDP_EDIR}/licenses"
		"${INTEL_SDP_EDIR}/Licenses"
		"${EPREFIX}/opt/intel/licenses"
		)
	for ((i = 0; i < ${#_dirs[@]}; i++)); do
		ebegin "Checking for a license in: ${_dirs[$i]}"
		[[ $( ls "${_dirs[$i]}"/*lic 2>/dev/null ) ]]; _ret=$?
		eend ${_ret}
		if [[ ${_ret} == "0" ]]; then
			_warn=${_ret}
			break
		fi
	done
	[[ ${_warn} == "0" ]] || big-warning pre-check

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
			INTEL_RPMS+=" intel-${p}-${_INTEL_PV4}-${_INTEL_PV1}.${_INTEL_PV2}-${_INTEL_PV3}.${a}.rpm"
		done
	done
	for p in ${INTEL_DAT_RPMS}; do
		INTEL_RPMS+=" intel-${p}-${_INTEL_PV4}-${_INTEL_PV1}.${_INTEL_PV2}-${_INTEL_PV3}.noarch.rpm"
	done

	case "${EAPI:-0}" in
		0|1|2|3) intel-sdp_pkg_pretend ;;
	esac
}

# @ ECLASS-FUNCTION: intel-sdp_src_unpack
# @DESCRIPTION:
# Unpacking necessary rpms from tarball, extract them and rearrange the output.
intel-sdp_src_unpack() {
	local l r subdir rb t list=()

	for t in ${A}; do
		for r in ${INTEL_RPMS}; do
			for subdir in ${INTEL_RPMS_DIRS}; do
				rpmdir=${t%%.*}/${subdir}
				list+=( ${rpmdir}/${r})
			done
		done
		tar xf "${DISTDIR}"/${t} ${list[@]}  2> /dev/null || die
		for r in ${list[@]}; do
			rb=$(basename ${r})
			l=.${rb}_$(date +'%d%m%y_%H%M%S').log
			einfo "Unpacking ${rb}"
			rpm2tar -O ${r} | tar xvf - | sed -e \
				"s:^\.:${EROOT#/}:g" > ${l} || die "unpacking ${r} failed"
			mv ${l} opt/intel/ || die "failed moving extract log file"
		done
	done

	mv opt/intel/* ${INTEL_SDP_DIR} || die "mv to INTEL_SDP_DIR failed"
}

# @ ECLASS-FUNCTION: intel-sdp_src_install
# @DESCRIPTION:
# Install everything
intel-sdp_src_install() {
	dodoc -r "${INTEL_SDP_DIR}"/Documentation/*

	ebegin "Cleaning out documentation"
	find "${INTEL_SDP_DIR}"/Documentation -delete || die
	eend

	if use examples && [[ -d "${INTEL_SDP_DIR}"/Samples ]]; then
		insinto /usr/share/${P}/examples/
		doins -r "${INTEL_SDP_DIR}"/Samples/*
	fi
	ebegin "Cleaning out examples"
	find "${INTEL_SDP_DIR}"/Samples -delete || die
	eend

	if [[ -d "${INTEL_SDP_DIR}"/eclipse_support ]]; then
		if has eclipse ${IUSE} && use eclipse; then
			intel_link_eclipse_plugins
		else
			ebegin "Cleaning out eclipse plugin"
			find "${INTEL_SDP_DIR}"/eclipse_support -delete || die
			eend
		fi
	fi

	if [[ -d "${INTEL_SDP_DIR}"/man ]]; then
		doman "${INTEL_SDP_DIR}"/man/en_US/man1/*
		use linguas_ja && \
			doman -i18n=ja_JP "${INTEL_SDP_DIR}"/man/ja_JP/man1/*

		find "${INTEL_SDP_DIR}"/man -delete || die
	fi

	use statc-libs || \
		find opt -type f -name "*.a" -delete || die

	ebegin "Tagging ${PN}"
	find opt -name \*sh -type f -exec sed -i \
		-e "s:<.*DIR>:${INTEL_SDP_EDIR}:g" \
		'{}' + || die
	eend

	[[ -d "${ED}" ]] || dodir /
	mv opt "${ED}"/ || die "moving files failed"

	dodir "${INTEL_SDP_EDIR}"/licenses
	keepdir "${INTEL_SDP_EDIR}"/licenses
}

# @ECLASS-FUNCTION
# @DESCRIPTION:
# Add things to intel database
intel-sdp_pkg_postinst() {
	# add product registry to intel "database"
	local l r
	for r in ${INTEL_RPMS}; do
		l="$(ls -1 ${EROOT%/}/opt/intel/.${r}_*.log | head -n 1)"
		echo >> ${INTEL_SDP_DB} \
			"<:${r%-${_INTEL_PV4}*}-${_INTEL_PV4}:${r}:${INTEL_SDP_EDIR}:${l}:>"
	done
	run-test
}

# @ECLASS-FUNCTION
# @DESCRIPTION:
# Sanitize intel database
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
	4|5) EXPORT_FUNCTIONS pkg_pretend ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac
