#!/bin/env bash
# For this script we need
# - net-misc/wget
# - app-arch/rpm
# - app-portage/gentoolkit
# - app-portage/eix
# - sys-apps/portage
# - app-portage/repoman
# - app-admin/sudo

# Sub-dir where the rpm files are at, this should be the only thing you have to edit
rpm_location="fetch-restrict/"

list_rpms="$(ls -1 ${rpm_location}*.rpm)"

for rpm in ${list_rpms}; do
	printf "\nFound ${rpm}\n"

	name=$(rpm -q "${rpm}" --qf "%{NAME}\n")
	version=$(rpm -q "${rpm}" --qf "%{VERSION}\n")
	revision=$(rpm -q "${rpm}" --qf "%{RELEASE}\n" | sed 's/[^0123456789].*//')
	if [ -z "${revision}" ]; then
		# revision is empty, set to 0
		revision="0"
	fi
	description=$(rpm -q "${rpm}" --qf "%{SUMMARY}\n")
	homepage=$(rpm -q "${rpm}" --qf "%{URL}\n" )
	if [[ "${homepage}" == "(none)" ]]; then
		# url is empty, set a sensible default
		homepage="https://${rpm_location}"
	fi
	dependencies=$(rpm -qR "${rpm}")

	# Skip unnecessary dependencies
	ebuild_deps=""
	IFS=$'\n'
	for dep in ${dependencies}; do
		if [[ ${dep} == *"/bin/sh"* ]]; then
			ebuild_deps+="app-shells/bash\n"
		elif [[ ${dep} == *"bash"* ]]; then
			ebuild_deps+="app-shells/bash\n"
		elif [[ ${dep} == *"rpm"* ]]; then
			ebuild_deps+="app-arch/rpm\n"
		elif [[ ${dep} == *"kernel"* ]]; then
			ebuild_deps+="virtual/linux-sources\n"
		elif [[ ${dep} == *"config("*")"* ]]; then
			# Some rpms have a config(PN) entry as dep
			# skip this because we don't want to depend on self
			continue
		elif [[ ${dep} == *".so"* ]]; then
			# This is a library, find the package it belongs to
			printf "   Found library dependency, checking which package it belongs to\n"
			match=$(equery b -en ${dep%%(*})
			if [ -n "${match}" ]; then
				printf "      Found matching package ${match} for dependency ${dep}\n"
				ebuild_deps+="${match}\n"
			else
				printf "      WARNING: No matching package found for library dependency: ${dep}\n"
			fi
		else
			# Read into array so we can separate the name and version number of the dep
			IFS=' '
			read -ra dep_arr <<< "${dep}"
			dep_name="${dep_arr[0]}"
			dep_operator="${dep_arr[1]}"
			dep_version="${dep_arr[2]}"

			# Check if there exists a package whit this name
			match=$(eix --only-names --pattern --brief "${dep_name%%(*}")
			if [ -n "${match}" ]; then
				printf "   Found matching package ${match} for dependency ${dep_name}\n"
				ebuild_deps+="${match}\n"
			else
				printf "   Did not find match for ${dep_name}, assuming this is a new package from this rpm repo\n"
				# Replace dash with underscore and remove dots from the new dep name
				dep_name="${dep_name//-/_}"
				dep_name="${dep_name//.}"
				# Add 'r' for revision dependencies
				dep_version="${dep_version//-/-r}"
				if [ -n "${dep_operator}" ]; then
					if [[ "${dep_operator}" == '=' ]]; then
						# if the operator equals '=' change it to '~' to allow revisions
						dep_operator='~'
					fi
					# if there is an operator add it and version number to deps
					ebuild_deps+="${dep_operator}$(basename $(pwd))/${dep_name}-${dep_version}\n"
				else
					# if not then just add the name to deps
					ebuild_deps+="$(basename $(pwd))/${dep_name}\n"
				fi
			fi
		fi
	done

	# Sort dependencies and remove duplicates
	ebuild_deps=$( printf "${ebuild_deps}" | sort -u )

	# Remove dashes and dots from the name
	name="${name//-/_}"
	name="${name//.}"

	printf "\nCreating Ebuild for ${rpm}\n"
	printf "Name: ${name}\n"
	printf "Version: ${version}-r${revision}\n"
	printf "Homepage: ${homepage}\n"
	printf "Description: ${description}\n"
	printf "Deps: \n${ebuild_deps}\n"

	# Create package dir if it does not exist and cd
	mkdir -p "${name}"
	pushd "${name}" > /dev/null # make it silent

	cat << EOF > "${name}-${version}-r${revision}.ebuild"
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../$(basename "$0")

EAPI=7

inherit rpm-extended

DESCRIPTION="${description}"
HOMEPAGE="${homepage}"
SRC_URI="${rpm##*/}"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror fetch"

DEPEND="
${ebuild_deps}
"

pkg_nofetch() {
	einfo "This ebuild requires: \${SRC_URI}"
	einfo "Please download LabVIEW from https://www.ni.com/en-us/support/downloads/software-products/download.labview.html"
	einfo "Extract the ISOs and tarballs and place all the rpm files in your DESTDIR directory (e.g. /var/cache/distfiles)"
}
EOF

	cat << EOF > "metadata.xml"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE pkgmetadata SYSTEM "http://www.gentoo.org/dtd/metadata.dtd">
<pkgmetadata>
	<maintainer type="person">
		<email>andrewammerlaan@riseup.net</email>
		<name>Andrew Ammerlaan</name>
	</maintainer>
	<maintainer type="project">
		<email>sci@gentoo.org</email>
		<name>Gentoo Science Project</name>
	</maintainer>
</pkgmetadata>
EOF

	popd > /dev/null # make it silent
done

# No need to download everything twice
distdir="$(portageq distdir)"
printf "\nMoving rpms to ${distdir}\n"
sudo mv "${rpm_location}"*.rpm "${distdir}"

# Generate manifest file
printf "\nGenerating Manifest files\n"
repoman manifest

# Clean up download directory
rm -r "${rpm_location%%/*}"

printf "DONE: Do a manual check with \'repoman -dx full\' to ensure everything is correct\n"
