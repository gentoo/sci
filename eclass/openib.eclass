# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Alexey Shvetsov <alexxy@gentoo.org>
# Purpose:  Simplify working with OFED packages
#

inherit base eutils rpm

EXPORT_FUNCTIONS src_unpack

HOMEPAGE="http://www.openfabrics.org/"
LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0"

# @ECLASS-VARIABLE: OFED_VER
# @DESCRIPTION:
# Defines OFED version eg 1.4 or 1.4.0.1

# @ECLASS-VARIABLE: OFED_SUFFIX
# @DESCRIPTION:
# Defines OFED package suffix eg -1.ofed1.4


SRC_URI="http://www.openfabrics.org/downloads/OFED/ofed-${OFED_VER}/OFED-${OFED_VER}.tgz"

case ${PN} in
	openib-files)
		MY_PN="ofa_kernel"
		;;
	*)
		MY_PN="${PN}"
		;;
esac

case ${PV} in
	*p*)
		MY_PV="${PV/p/}"
		;;
	*)
		MY_PV="${PV}"
		;;
esac

case ${MY_PN} in
	ofa_kernel)
		EXT="tgz"
		;;
	*)
		EXT="tar.gz"
		;;
esac

S="${WORKDIR}/${MY_PN}-${MY_PV}"

# @FUNCTION: openib_src_unpack
# @DESCRIPTION:
# This function will unpack OFED packages
openib_src_unpack() {
	unpack ${A}
	rpm_unpack "./OFED-${OFED_VER}/SRPMS/${MY_PN}-${MY_PV}-${OFED_SUFFIX}.src.rpm"
	case ${MY_PN} in
		rds-tools)
			MY_PV="${PV}-${OFED_SUFFIX}"
			;;
		*)
			;;
	esac
	unpack ./${MY_PN}-${MY_PV}.${EXT}
}
