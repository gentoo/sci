#!/usr/bin/env bash
# Maintainer: Andrew Ammerlaan <andrewammerlaan@riseup.net>
#
# This checks if packages in ::science are also in ::gentoo
#
# Note that this is not going to be 100% accurate
#
#

printf "\nChecking for duplicates....\n"

gentoo_location="/var/db/repos/gentoo"
science_location="."

gentoo_packs=$(find ${gentoo_location} -mindepth 2 -maxdepth 2 -printf "%P\n" | sort | grep -Ev "^(.git|.github|metadata|profiles|scripts)/")
science_packs=$(find ${science_location} -mindepth 2 -maxdepth 2 -printf "%P\n" | sort | grep -Ev "^(.git|.github|metadata|profiles|scripts)/")

pack_overrides="" pack_close_match_in_cat="" pack_close_match=""
for science_pack in ${science_packs}; do
	# separate category and packages
	science_pack_cat="${science_pack%%/*}"
	science_pack_name="${science_pack##*/}"

	# convert all to lowercase
	science_pack_name="${science_pack_name,,}"

	# stip all numbers, dashes, underscores and pluses
	science_pack_name="${science_pack_name/[0-9-_+]}"

	for gentoo_pack in ${gentoo_packs}; do
		# separate category and packages
		gentoo_pack_cat="${gentoo_pack%%/*}"
		gentoo_pack_name="${gentoo_pack##*/}"

		# convert all to lowercase
		gentoo_pack_name="${gentoo_pack_name,,}"

		# stip all numbers, dashes, underscores and pluses
		gentoo_pack_name="${gentoo_pack_name/[0-9-_+]}"

		#TODO: check DESCRIPTION, HOMEPAGE and SRC_URI for close matches

		if [[ "${gentoo_pack_name}" == "${science_pack_name}" ]]; then
			if [[ "${gentoo_pack_cat}" == "${science_pack_cat}" ]]; then
				if [[ "${gentoo_pack}" == "${science_pack}" ]]; then
					pack_overrides+="\t${science_pack}::science exact match of ${gentoo_pack}::gentoo\n"
				else
					pack_close_match_in_cat+="\t${science_pack}::science possible duplicate of ${gentoo_pack}::gentoo\n"
				fi
			else
				pack_close_match+="\t${science_pack}::science possible duplicate of ${gentoo_pack}::gentoo\n"
			fi
		fi
	done
done

if [ -n "${pack_close_match}" ]; then
	printf "\nWARNING: The following packages closely match packages in the main Gentoo repository\n"
	printf "${pack_close_match}"
	printf "Please check these manually\n"
fi

if [ -n "${pack_close_match_in_cat}" ]; then
	printf "\nWARNING: The following packages closely match packages in the main Gentoo repository in the same category\n"
	printf "${pack_close_match_in_cat}"
	printf "Please check these manually\n"
fi

if [ -n "${pack_overrides}" ]; then
	printf "\nERROR: The following packages override packages in the main Gentoo repository\n"
	printf "${pack_overrides}"
	printf "Please remove these packages\n"
	# do not exit fatally on ::science
	# exit 1
fi
exit 0
