# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: intel-sdp-r1.eclass
# @MAINTAINER:
# Justin Lecher <jlec@gentoo.org>
# David Seifert <soap@gentoo.org>
# Sci Team <sci@gentoo.org>
# @BLURB: Handling of Intel's Software Development Products package management

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit check-reqs eutils multilib-build versionator

EXPORT_FUNCTIONS src_unpack src_install pkg_postinst pkg_postrm pkg_pretend

if [[ ! ${_INTEL_SDP_R1_ECLASS_} ]]; then

case "${EAPI}" in
	6) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# @ECLASS-VARIABLE: INTEL_DIST_SKU
# @DEFAULT_UNSET
# @DESCRIPTION:
# The package download ID from Intel.
# To determine its value, see the links to download in
# https://registrationcenter.intel.com/RegCenter/MyProducts.aspx
#
# e.g. 8365
#
# Must be defined before inheriting the eclass.

# @ECLASS-VARIABLE: INTEL_DIST_NAME
# @DESCRIPTION:
# The package name to download from Intel.
# To determine its value, see the links to download in
# https://registrationcenter.intel.com/RegCenter/MyProducts.aspx
#
# e.g. parallel_studio_xe
#
# Must be defined before inheriting the eclass.
: ${INTEL_DIST_NAME:=parallel_studio_xe}

# @ECLASS-VARIABLE: INTEL_DIST_PV
# @DEFAULT_UNSET
# @DESCRIPTION:
# The package download version from Intel.
# To determine its value, see the links to download in
# https://registrationcenter.intel.com/RegCenter/MyProducts.aspx
#
# e.g. 2016_update1
#
# Must be defined before inheriting the eclass.

# @ECLASS-VARIABLE: INTEL_DIST_TARX
# @DESCRIPTION:
# The package distfile suffix.
# To determine its value, see the links to download in
# https://registrationcenter.intel.com/RegCenter/MyProducts.aspx
#
# e.g. tgz
#
# Must be defined before inheriting the eclass.
: ${INTEL_DIST_TARX:=tgz}

# @ECLASS-VARIABLE: INTEL_SUBDIR
# @DESCRIPTION:
# The package sub-directory (without version numbers) where it will end-up in /opt/intel
#
# e.g. compilers_and_libraries
#
# To determine its value, you have to do a raw install from the Intel tarball.
: ${INTEL_SUBDIR:=compilers_and_libraries}

# @ECLASS-VARIABLE: INTEL_SKIP_LICENSE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Possibility to skip the mandatory check for licenses. Only set this if there
# is really no fix.

# @ECLASS-VARIABLE: INTEL_RPMS_DIR
# @DESCRIPTION:
# Main subdirectory which contains the rpms to extract.
: ${INTEL_RPMS_DIR:=rpm}

# @ECLASS-VARIABLE: INTEL_X86
# @DESCRIPTION:
# 32bit arch in rpm names
#
# e.g. i486
: ${INTEL_X86:=i486}

# @ECLASS-VARIABLE: INTEL_DIST_BIN_RPMS
# @DESCRIPTION:
# Functional name of rpm without any version/arch tag.
# Has to be a bash array
#
# e.g. ("icc-l-all-devel")
#
# if the rpm is located in a directory other than INTEL_RPMS_DIR you can
# specify the full path
#
# e.g. ("CLI_install/rpm/intel-vtune-amplifier-xe-cli")
[[ ${INTEL_DIST_BIN_RPMS[@]} ]] || INTEL_DIST_BIN_RPMS=()

# @ECLASS-VARIABLE: INTEL_DIST_AMD64_RPMS
# @DESCRIPTION:
# AMD64 single arch rpms. Same syntax as INTEL_DIST_BIN_RPMS.
# Has to be a bash array.
[[ ${INTEL_DIST_AMD64_RPMS[@]} ]] || INTEL_DIST_AMD64_RPMS=()

# @ECLASS-VARIABLE: INTEL_DIST_X86_RPMS
# @DESCRIPTION:
# X86 single arch rpms. Same syntax as INTEL_DIST_BIN_RPMS.
# Has to be a bash array.
[[ ${INTEL_DIST_X86_RPMS[@]} ]] || INTEL_DIST_X86_RPMS=()

# @ECLASS-VARIABLE: INTEL_DIST_DAT_RPMS
# @DESCRIPTION:
# Functional name of rpm of common data which are arch free
# without any version tag. Has to be a bash array.
#
# e.g. ("openmp-l-all-devel")
#
# if the rpm is located in a directory different to INTEL_RPMS_DIR you can
# specify the full path
#
# e.g. ("CLI_install/rpm/intel-vtune-amplifier-xe-cli-common")
[[ ${INTEL_DIST_DAT_RPMS[@]} ]] || INTEL_DIST_DAT_RPMS=()

# @ECLASS-VARIABLE: INTEL_DIST_SPLIT_ARCH
# @DESCRIPTION:
# Set to "true" if arches are to be fetched separately, instead of using
# the combined tarball.
: ${INTEL_DIST_SPLIT_ARCH:=false}

# @FUNCTION: _isdp_get-sdp-full-pv
# @INTERNAL
# @DESCRIPTION:
# Gets the full internal Intel version specifier.
_isdp_get-sdp-full-pv() {
	local _intel_pv=($(get_version_components))
	case ${#_intel_pv[@]} in
		3)
			local _intel_pv_full="${_intel_pv[0]}.${_intel_pv[1]}-${_intel_pv[2]}"
			;;
		4)
			local _intel_pv_full="${_intel_pv[3]}-${_intel_pv[0]}.${_intel_pv[1]}.${_intel_pv[2]}-${_intel_pv[3]}"
			;;
	esac
	echo "${_intel_pv_full}"
}

# @FUNCTION: _isdp_get-sdp-year
# @INTERNAL
# @DESCRIPTION:
# Gets the year component from INTEL_DIST_PV
_isdp_get-sdp-year() {
	local _intel_sdp_year
	_intel_sdp_year=${INTEL_DIST_PV}
	_intel_sdp_year=${_intel_sdp_year%_sp*}
	_intel_sdp_year=${_intel_sdp_year%_update*}
	echo "${_intel_sdp_year}"
}

# @FUNCTION: isdp_get-sdp-dir
# @DESCRIPTION:
# Gets the full rootless path to the installation directory
#
#     e.g. opt/intel/compilers_and_libraries_2016.1.150
isdp_get-sdp-dir() {
	local _intel_sdp_dir="opt/intel/${INTEL_SUBDIR}_$(_isdp_get-sdp-year).$(get_version_component_range 3-4)"
	echo "${_intel_sdp_dir}"
}

# @FUNCTION: isdp_get-sdp-edir
# @DESCRIPTION:
# Gets the full rooted/prefixed path to the installation directory
#
#     e.g. /opt/intel/compilers_and_libraries_2016.1.150
isdp_get-sdp-edir() {
	local _intel_sdp_edir="${EPREFIX%/}/$(isdp_get-sdp-dir)"
	echo "${_intel_sdp_edir}"
}

_INTEL_URI="http://registrationcenter-download.intel.com/akdlm/irc_nas/${INTEL_DIST_SKU}/${INTEL_DIST_NAME}"
if [[ "${INTEL_DIST_SPLIT_ARCH}" != true ]]; then
	SRC_URI="${_INTEL_URI}_${INTEL_DIST_PV}.${INTEL_DIST_TARX}"
else
	SRC_URI="
		abi_x86_32? ( ${_INTEL_URI}_${INTEL_DIST_PV}_ia32.${INTEL_DIST_TARX} )
		abi_x86_64? ( ${_INTEL_URI}_${INTEL_DIST_PV}_intel64.${INTEL_DIST_TARX} )"
fi
unset _INTEL_URI

LICENSE="Intel-SDP"
# TODO: Proper slotting
# Future work, #394411
SLOT="0"

RESTRICT="mirror"

RDEPEND=""
DEPEND="app-arch/rpm2targz"

S="${WORKDIR}"

QA_PREBUILT="$(isdp_get-sdp-dir)/*"

# @FUNCTION: isdp_convert2intel-arch
# @USAGE: <arch>
# @DESCRIPTION:
# Convert between portage arch (e.g. amd64, x86) and intel installed arch
# nomenclature (e.g. intel64, ia32)
isdp_convert2intel-arch() {
	debug-print-function ${FUNCNAME} "${@}"

	case $1 in
		*amd64*|abi_x86_64)
			echo "intel64"
			;;
		*x86*)
			echo "ia32"
			;;
		*)
			die "Abi \'$1\' is unsupported"
			;;
	esac
}

# @FUNCTION: isdp_get-native-abi-arch
# @DESCRIPTION:
# Determine the the intel arch string of the native ABI
isdp_get-native-abi-arch() {
	debug-print-function ${FUNCNAME} "${@}"

	use amd64 && echo "$(isdp_convert2intel-arch abi_x86_64)"
	use x86 && echo "$(isdp_convert2intel-arch abi_x86_32)"
}

# @FUNCTION: isdp_get-sdp-installed-arches
# @DESCRIPTION:
# Returns a space separated list of the arch suffixes used in directory
# names for enabled ABIs. Intel uses "ia32" for x86 and "intel64" for
# amd64. The result would be "ia32 intel64" if both ABIs were enabled.
isdp_get-sdp-installed-arches() {
	local arch=()
	use abi_x86_64 && arch+=($(isdp_convert2intel-arch abi_x86_64))
	use abi_x86_32 && arch+=($(isdp_convert2intel-arch abi_x86_32))
	echo "${arch[*]}"
}

# @FUNCTION: _isdp_get-sdp-source-rpm-arches
# @INTERNAL
# @DESCRIPTION:
# Returns a space separated list of the arch suffixes used in the RPM filenames, e.g.
#
#    intel-openmp-l-all-150-16.0.1-150.i486.rpm
#    intel-openmp-l-all-150-16.0.1-150.x86_64.rpm
#
# the result would consist of "i486 x86_64".
_isdp_get-sdp-source-rpm-arches() {
	local arch=()
	use abi_x86_64 && arch+=("x86_64")
	use abi_x86_32 && arch+=("${INTEL_X86}")
	echo "${arch[*]}"
}

# @FUNCTION: _isdp_generate-list-install-rpms
# @INTERNAL
# @DESCRIPTION:
# Generates the list of fully expanded RPMs to be extracted.
_isdp_generate-list-install-rpms() {
	debug-print-function ${FUNCNAME} "${@}" 

	# Expand components into full RPM filenames
	expand_component_into_full_rpm() {
		local deref_var="${1}[@]"
		local arch="${2}"
		local p a rpm_prefix rpm_suffix expanded_full_rpms=()

		for p in "${!deref_var}"; do
			for a in ${arch}; do
				# check if a directory is prefixed
				if [[ "${p}" == "${p##*/}" ]]; then
					rpm_prefix="${INTEL_RPMS_DIR}/intel-"
				else
					rpm_prefix=""
				fi

				# check for variables ending in ".rpm"
				# these are excluded from version expansion, due to Intel's
				# idiosyncratic versioning scheme beginning with their 2016
				# suite of tools. For instance
				#
				#     intel-ccompxe-2016.1-056.noarch.rpm
				#
				# which is completely unpredictable using versions
				if [[ "${p}" == *.rpm ]]; then
					rpm_suffix=""
				else
					rpm_suffix="-$(_isdp_get-sdp-full-pv).${a}.rpm"
				fi

				expanded_full_rpms+=( "${rpm_prefix}${p}${rpm_suffix}" )
			done
		done
		echo ${expanded_full_rpms[*]}
	}

	local vars_to_expand=("INTEL_DIST_BIN_RPMS" "INTEL_DIST_DAT_RPMS")
	local vars_to_expand_suffixes=("$(_isdp_get-sdp-source-rpm-arches)" "noarch")
	if use abi_x86_32; then
		vars_to_expand+=("INTEL_DIST_X86_RPMS")
		vars_to_expand_suffixes+=("${INTEL_X86}")
	fi
	if use abi_x86_64; then
		vars_to_expand+=("INTEL_DIST_AMD64_RPMS")
		vars_to_expand_suffixes+=("x86_64")
	fi

	local i fully_expanded_intel_rpms=()
	for ((i=0; i<${#vars_to_expand[@]}; i++)); do
		fully_expanded_intel_rpms+=($(expand_component_into_full_rpm "${vars_to_expand[i]}" "${vars_to_expand_suffixes[i]}"))
	done
	echo ${fully_expanded_intel_rpms[*]}
}

# @FUNCTION: _isdp_big-warning
# @USAGE: [pre-check | test-failed]
# @INTERNAL
# @DESCRIPTION:
# warn user that we really require a license
_isdp_big-warning() {
	debug-print-function ${FUNCNAME} "${@}"

	case ${1} in
		pre-check )
			ewarn "License file not found!"
			;;

		test-failed )
			ewarn "Function test failed. Most probably due to an invalid license."
			ewarn "This means you already tried to bypass the license check once."
			;;
	esac

	ewarn
	ewarn "Make sure you have received an Intel license."
	ewarn "To receive a non-commercial license, you need to register at:"
	ewarn "https://software.intel.com/en-us/qualify-for-free-software"
	ewarn "Install the license file into ${EPREFIX}/opt/intel/licenses"
	ewarn
	ewarn "Beginning with the 2016 suite of tools, license files are keyed"
	ewarn "to the MAC address of the eth0 interface. In order to retrieve"
	ewarn "a personalized license file, follow the instructions at"
	ewarn "https://software.intel.com/en-us/articles/how-do-i-get-my-license-file-for-intel-parallel-studio-xe-2016"

	case ${1} in
		pre-check )
			ewarn "before proceeding with installation of ${P}"
			;;
		* )
			;;
	esac
}

# @FUNCTION: _isdp_version_test
# @INTERNAL
# @DESCRIPTION:
# Testing for valid license by asking for version information of the compiler.
_isdp_version_test() {
	debug-print-function ${FUNCNAME} "${@}"

	local comp
	case ${PN} in
		ifc )
			debug-print "Testing ifort"
			comp=ifort
			;;
		icc )
			debug-print "Testing icc"
			comp=icc
			;;
		*)
			die "${PN} is not supported for testing"
			;;
	esac

	local comp_full arch warn
	for arch in $(isdp_get-sdp-installed-arches); do
		case ${EBUILD_PHASE} in
			install )
				comp_full="${ED%/}/$(isdp_get-sdp-dir)/linux/bin/${arch}/${comp}"
				;;
			postinst )
				comp_full="$(isdp_get-sdp-edir)/linux/bin/${arch}/${comp}"
				;;
			* )
				die "Compile test not supported in ${EBUILD_PHASE}"
				;;
		esac

		debug-print "LD_LIBRARY_PATH=\"$(isdp_get-sdp-edir)/linux/bin/${arch}/\" \"${comp_full}\" -V"

		LD_LIBRARY_PATH="$(isdp_get-sdp-edir)/linux/bin/${arch}/" "${comp_full}" -V &>/dev/null || warn=yes
	done
	[[ ${warn} == yes ]] && _isdp_big-warning test-failed
}

# @FUNCTION: _isdp_run-test
# @INTERNAL
# @DESCRIPTION:
# Test if installed compiler is working.
_isdp_run-test() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ -z ${INTEL_SKIP_LICENSE} ]]; then
		case ${PN} in
			ifc | icc )
				_isdp_version_test
				;;
			* )
				debug-print "No test available for ${PN}"
				;;
		esac
	fi
}

# @FUNCTION: intel-sdp-r1_pkg_pretend
# @DESCRIPTION:
#
# * Check for a (valid) license before proceeding.
#
# * Check for space requirements being fulfilled.
#
intel-sdp-r1_pkg_pretend() {
	debug-print-function ${FUNCNAME} "${@}"

	local warn=1 dir dirs ret arch a p

	: ${CHECKREQS_DISK_BUILD:=256M}
	check-reqs_pkg_pretend

	if [[ -z ${INTEL_SKIP_LICENSE} ]]; then
		if [[ ${INTEL_LICENSE_FILE} == *@* ]]; then
			einfo "Looks like you are using following license server:"
			einfo "   ${INTEL_LICENSE_FILE}"
			return 0
		fi

		dirs=(
			"${EPREFIX}/opt/intel/licenses"
			"$(isdp_get-sdp-edir)/licenses"
			"$(isdp_get-sdp-edir)/Licenses"
			)
		for dir in "${dirs[@]}" ; do
			ebegin "Checking for a license in: ${dir}"
			path_exists "${dir}"/*lic && warn=0
			eend ${warn} && break
		done
		if [[ ${warn} == 1 ]]; then
			_isdp_big-warning pre-check
			die "Could not find license file"
		fi
	else
		eqawarn "The ebuild doesn't check for presence of a proper intel license!"
		eqawarn "This shouldn't be done unless there is a very good reason."
	fi
}

# @FUNCTION: intel-sdp-r1_src_unpack
# @DESCRIPTION:
# Unpacking necessary rpms from tarball, extract them and rearrange the output.
intel-sdp-r1_src_unpack() {
	local t
	for t in ${A}; do
		local r list=() source_rpms=($(_isdp_generate-list-install-rpms))
		for r in "${source_rpms[@]}"; do
			list+=( ${t%%.*}/${r} )
		done

		local debug_list
		debug_list="$(IFS=$'\n'; echo ${list[@]} )"

		debug-print "Adding to decompression list:"
		debug-print ${debug_list}

		tar -xvf "${DISTDIR}"/${t} ${list[@]} &> "${T}"/rpm-extraction.log

		for r in ${list[@]}; do
			einfo "Unpacking ${r}"
			printf "\nUnpacking %s\n" "${r}" >> "${T}"/rpm-extraction.log
			rpm2tar -O ${r} | tar -xvf - &>> "${T}"/rpm-extraction.log; assert "Unpacking ${r} failed"
		done
	done
}

# @FUNCTION: intel-sdp-r1_src_install
# @DESCRIPTION:
# Install everything
intel-sdp-r1_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	local i
	# remove uninstall information
	ebegin "Cleaning out uninstall"
	while IFS='\n' read -r -d '' i; do
		rm -r "${i}" || die
	done < <(find opt -regextype posix-extended -regex '.*(uninstall|uninstall.sh)$' -print0)
	eend

	# remove remaining japanese stuff
	if ! use linguas_ja; then
		ebegin "Cleaning out japanese language directories"
		while IFS='\n' read -r -d '' i; do
			rm -r "${i}" || die
		done < <(find opt -type d -regextype posix-extended -regex '.*(ja|ja_JP)$' -print0)
		eend
	fi

	# handle documentation
	if path_exists "opt/intel/documentation_$(_isdp_get-sdp-year)"; then
		# normal man pages
		if path_exists "opt/intel/documentation_$(_isdp_get-sdp-year)/en/man/common/man1"; then
			doman opt/intel/documentation_"$(_isdp_get-sdp-year)"/en/man/common/man1/*
			rm -r opt/intel/documentation_"$(_isdp_get-sdp-year)"/en/man || die
		fi

		use doc && dodoc -r opt/intel/documentation_"$(_isdp_get-sdp-year)"/*

		ebegin "Cleaning out documentation"
		rm -r "opt/intel/documentation_$(_isdp_get-sdp-year)" || die
		rm -rf "$(isdp_get-sdp-dir)"/linux/{documentation,man} || die
		eend
	fi

	# MPI man pages
	if path_exists "$(isdp_get-sdp-dir)/linux/mpi/man/man3"; then
		doman "$(isdp_get-sdp-dir)"/linux/mpi/man/man3/*
		rm -r "$(isdp_get-sdp-dir)"/linux/mpi/man || die
	fi

	# licensing docs
	if path_exists "$(isdp_get-sdp-dir)/licensing/documentation"; then
		dodoc -r "$(isdp_get-sdp-dir)/licensing/documentation"/*
		rm -rf "$(isdp_get-sdp-dir)/licensing/documentation" || die
	fi

	if path_exists opt/intel/"${INTEL_DIST_NAME}"*/licensing; then
		dodoc -r opt/intel/"${INTEL_DIST_NAME}"*/licensing
		rm -rf opt/intel/"${INTEL_DIST_NAME}"* || die
	fi

	# handle examples
	if path_exists "opt/intel/samples_$(_isdp_get-sdp-year)"; then
		use examples && dodoc -r opt/intel/samples_"$(_isdp_get-sdp-year)"/*

		ebegin "Cleaning out examples"
		rm -r "opt/intel/samples_$(_isdp_get-sdp-year)" || die
		eend
	fi

	# remove eclipse unconditionally
	ebegin "Cleaning out eclipse files"
	rm -rf opt/intel/ide_support_* || die
	eend

	# repair shell scripts used for sourcing PATH (iccvars.sh and such)
	ebegin "Tagging ${PN}"
	find opt -name \*sh -type f -exec sed -i \
		-e "s:<.*DIR>:$(isdp_get-sdp-edir)/linux:g" \
		'{}' + || die
	eend

	ebegin "Removing broken symlinks"
	while IFS='\n' read -r -d '' i; do
		rm "${i}" || die
	done < <(find opt -xtype l -print0)
	eend

	mv opt "${ED%/}"/ || die "moving files failed"

	keepdir "$(isdp_get-sdp-dir)"/licenses /opt/intel/ism/rm
}

# @FUNCTION: intel-sdp-r1_pkg_postinst
# @DESCRIPTION:
# Test for all things working
intel-sdp-r1_pkg_postinst() {
	debug-print-function ${FUNCNAME} "${@}"

	_isdp_run-test

	if [[ ${PN} = icc ]] && has_version ">=dev-util/ccache-3.1.9-r2" ; then
		#add ccache links as icc might get installed after ccache
		"${EROOT}"/usr/bin/ccache-config --install-links
	fi

	elog "Beginning with the 2016 suite of Intel tools, Gentoo has removed"
	elog "support for the eclipse plugin. If you require the IDE support,"
	elog "you will have to install the suite on your own, outside portage."
}

# @FUNCTION: intel-sdp-r1_pkg_postrm
# @DESCRIPTION:
# Sanitize cache links
intel-sdp-r1_pkg_postrm() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${PN} = icc ]] && has_version ">=dev-util/ccache-3.1.9-r2" && [[ -z ${REPLACED_BY_VERSION} ]]; then
		# --remove-links would remove all links, --install-links updates them
		"${EROOT}"/usr/bin/ccache-config --install-links
	fi
}

_INTEL_SDP_R1_ECLASS_=1
fi
