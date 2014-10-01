# Copyright 2010-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Based in part upon 'alternatives.exlib' from Exherbo, which is:
# Copyright 2008, 2009 Bo Ørsted Andresen
# Copyright 2008, 2009 Mike Kelly
# Copyright 2009 David Leverton

# @ECLASS: alternatives-2
# @MAINTAINER:
# Gentoo Science Project <sci@gentoo.org>
# @BLURB: Manage alternative implementations.
# @DESCRIPTION:
# Autogenerate eselect modules for alternatives and ensure that valid provider
# is set.
#
# Remove eselect modules when last provider is unmerged.
#
# If your package provides pkg_postinst or pkg_prerm phases, you need to be
# sure you explicitly run alternatives-2_pkg_{postinst,prerm} where appropriate.

case "${EAPI:-0}" in
	0|1|2|3)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	4|5)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

DEPEND=">=app-admin/eselect-1.4.3-r100"
RDEPEND="${DEPEND}
	!app-admin/eselect-blas
	!app-admin/eselect-cblas
	!app-admin/eselect-lapack"

EXPORT_FUNCTIONS pkg_postinst pkg_prerm

# @ECLASS-VARIABLE: ALTERNATIVES_DIR
# @INTERNAL
# @DESCRIPTION:
# Alternatives directory with symlinks managed by eselect.
ALTERNATIVES_DIR="/etc/env.d/alternatives"

# @FUNCTION: alternatives_for
# @USAGE: alternative provider importance source target [source target [...]]
# @DESCRIPTION:
# Set up alternative provider.
#
# EXAMPLE:
# @CODE
# alternatives_for cblas atlas 0 \
#     /usr/$(get_libdir)/pkgconfig/cblas.pc atlas-cblas.pc \
#     /usr/include/cblas.h atlas/cblas.h
# @CODE
alternatives_for() {
	(( $# >= 5 )) && (( ($#-3)%2 == 0)) || die "${FUNCNAME} requires exactly 3+N*2 arguments where N>=1"
	local alternative=${1} provider=${2} importance=${3} index src target ret=0
	shift 3

	# Make sure importance is a signed integer
	if [[ -n ${importance} ]] && ! [[ ${importance} =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
		eerror "Invalid importance (${importance}) detected"
		((ret++))
	fi

	# Create alternative provider subdirectories under ALTERNATIVES_DIR if needed
	[[ -d "${ED}${ALTERNATIVES_DIR}/${alternative}/${provider}" ]] || dodir "${ALTERNATIVES_DIR}/${alternative}/${provider}"

	# Keep track of provided alternatives for use in pkg_{postinst,prerm}.
	# Keep a mapping between importance and provided alternatives
	# and make sure the former is set to only one value.
	if ! has "${alternative}:${provider}" "${ALTERNATIVES_PROVIDED[@]}"; then
		# Add new provider and set its importance
		index=${#ALTERNATIVES_PROVIDED[@]}
		ALTERNATIVES_PROVIDED+=( "${alternative}:${provider}" )
		ALTERNATIVES_IMPORTANCE[index]=${importance}
		[[ -n ${importance} ]] && echo "${importance}" > "${ED}${ALTERNATIVES_DIR}/${alternative}/${provider}/_importance"
	else
		# Set importance for existing provider
		for((index=0;index<${#ALTERNATIVES_PROVIDED[@]};index++)); do
			if [[ ${alternative}:${provider} == ${ALTERNATIVES_PROVIDED[index]} ]]; then
				if [[ -n ${ALTERNATIVES_IMPORTANCE[index]} ]]; then
					if [[ -n ${importance} && ${ALTERNATIVES_IMPORTANCE[index]} != ${importance} ]]; then
						eerror "Differing importance (${ALTERNATIVES_IMPORTANCE[index]} != ${importance}) detected"
						((ret++))
					fi
				else
					ALTERNATIVES_IMPORTANCE[index]=${importance}
					[[ -n ${importance} ]] && echo "${importance}" > "${ED}${ALTERNATIVES_DIR}/${alternative}/${provider}/_importance"
				fi
			fi
		done
	fi

	# Process source-target pairs
	while (( $# >= 2 )); do
		src=${1//+(\/)/\/}; target=${2//+(\/)/\/}
		if [[ ${src} != /* ]]; then
			eerror "Source path must be absolute, but got ${src}"
			((ret++))

		else
			local reltarget= dir=${ALTERNATIVES_DIR}/${alternative}/${provider}${src%/*}
			while [[ -n ${dir} ]]; do
				reltarget+=../
				dir=${dir%/*}
			done

			reltarget=${reltarget%/}
			[[ ${target} == /* ]] || reltarget+=${src%/*}/
			reltarget+=${target}
			dodir "${ALTERNATIVES_DIR}/${alternative}/${provider}${src%/*}"
			dosym "${reltarget}" "${ALTERNATIVES_DIR}/${alternative}/${provider}${src}"

			# The -e test will fail if existing symlink points to non-existing target,
			# so check for -L also.
			# Say ${ED}/sbin/init exists and links to /bin/systemd (which doesn't exist yet).
			if [[ -e ${ED}${src} || -L ${ED}${src} ]]; then
				local fulltarget=${target}
				[[ ${fulltarget} != /* ]] && fulltarget=${src%/*}/${fulltarget}
				if [[ -e ${ED}${fulltarget} || -L ${ED}${fulltarget} ]]; then
					die "${src} defined as provider for ${fulltarget}, but both already exist in \${ED}"
				else
					mv "${ED}${src}" "${ED}${fulltarget}" || die
				fi
			fi
		fi
		shift 2
	done

	# Stop if there were any errors
	[[ ${ret} -eq 0 ]] || die "Errors detected for ${provider}, provided for ${alternative}"
}

# @FUNCTION: cleanup_old_alternatives_module
# @USAGE: alternative
# @DESCRIPTION:
# Remove old alternatives module.
cleanup_old_alternatives_module() {
	local alt=${1} old_module="${EROOT%/}/usr/share/eselect/modules/${alt}.eselect"
	if [[ -f "${old_module}" && $(grep 'ALTERNATIVE=' "${old_module}" | cut -d '=' -f 2) == "${alt}" ]]; then
		local version="$(grep 'VERSION=' "${old_module}" | grep -o '[0-9.]\+')"
		if [[ "${version}" == "0.1" || "${version}" == "20080924" ]]; then
			echo "rm ${old_module}"
			rm "${old_module}" || eerror "rm ${old_module} failed"
		fi
	fi
}

# @FUNCTION: alternatives-2_pkg_postinst
# @DESCRIPTION:
# Create eselect modules for all provided alternatives if necessary and ensure
# that valid provider is set.
#
# Also remove old eselect modules for provided alternatives.
#
# Provided alternatives are set up using alternatives_for().
alternatives-2_pkg_postinst() {
	local a alt provider module_version="20090908"
	local EAUTO="${EROOT%/}/usr/share/eselect/modules/auto"
	for a in "${ALTERNATIVES_PROVIDED[@]}"; do
		alt="${a%:*}"
		provider="${a#*:}"
		if [[ ! -f "${EAUTO}/${alt}.eselect" \
			|| "$(grep '^VERSION=' "${EAUTO}/${alt}.eselect" | grep -o '[0-9]\+')" \
				-ne "${module_version}" ]]; then
			if [[ ! -d ${EAUTO} ]]; then
				install -d "${EAUTO}" || eerror "Could not create eselect modules dir"
			fi
			einfo "Creating alternatives eselect module for ${alt}"
			cat > "${EAUTO}/${alt}.eselect" <<-EOF
				# This module was automatically generated by alternatives-2.eclass
				DESCRIPTION="Alternatives for ${alt}"
				VERSION="${module_version}"
				MAINTAINER="eselect@gentoo.org"
				ESELECT_MODULE_GROUP="Alternatives"

				ALTERNATIVE="${alt}"

				inherit alternatives
			EOF
		fi

		# Set alternative provider if there is no valid provider selected
		eselect "${alt}" update "${provider}"

		cleanup_old_alternatives_module ${alt}
	done
}

# @FUNCTION: alternatives-2_pkg_prerm
# @DESCRIPTION:
# Ensure a valid provider is set in case the package is unmerged and
# remove autogenerated eselect modules for all alternatives when last
# provider is unmerged.
#
# Provided alternatives are set up using alternatives_for().
alternatives-2_pkg_prerm() {
	local a alt provider ignore ret
	local EAUTO="${EROOT%/}/usr/share/eselect/modules/auto"
	# If we are uninstalling, update alternatives to valid provider
	[[ -n ${REPLACED_BY_VERSION} ]] || ignore="--ignore"
	for a in "${ALTERNATIVES_PROVIDED[@]}"; do
		alt="${a%:*}"
		provider="${a#*:}"
		eselect "${alt}" update ${ignore} "${provider}"
		ret=$?
		[[ -n ${REPLACED_BY_VERSION} ]] || \
			einfo "Removing ${provider} alternative module for ${alt}, current is $(eselect ${alt} show)"
		case ${ret} in
			0) : ;;
			2)
				# This was last provider for the alternative, remove eselect module
				einfo "Cleaning up unused alternatives module for ${alt}"
				rm "${EAUTO}/${alt}.eselect" || \
					eerror "rm ${EAUTO}/${alt}.eselect failed"
				;;
			*)
				eerror "eselect ${alt} update ${provider} returned ${ret}"
				;;
		esac
	done
}
