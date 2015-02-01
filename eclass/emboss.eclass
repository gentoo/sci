# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/emboss.eclass,v 1.3 2012/09/27 16:35:41 axs Exp $

# @ECLASS: emboss.eclass
# @MAINTAINER:
# sci-biology@gentoo.org
# jlec@gentoo.org
# @AUTHOR:
# Original author: Author Olivier Fisette <ofisette@gmail.com>
# Next gen author: Justin Lecher <jlec@gentoo.org>
# @BLURB: Use this to easy install EMBOSS and EMBASSY programs (EMBOSS add-ons).
# @DESCRIPTION:
# The inheriting ebuild must set EAPI=4 and provide EBO_DESCRIPTION before the inherit line.
# KEYWORDS should be set. Additionally "(R|P)DEPEND"encies and other standard
# ebuild variables can be extended (FOO+=" bar").
# Default installation of following DOCS="AUTHORS ChangeLog NEWS README"
#
# Example:
#
# EAPI="4"
#
# EBO_DESCRIPTION="applications from the CBS group"
#
# inherit emboss

# @ECLASS-VARIABLE: EBO_DESCRIPTION
# @DESCRIPTION:
# Should be set. Completes the generic description of the embassy module as follows:
#
# EMBOSS integrated version of ${EBO_DESCRIPTION},
# e.g.
# "EMBOSS integrated version of applications from the CBS group"
#
# Defaults to the upstream name of the module.

# @ECLASS-VARIABLE: EBO_EXTRA_ECONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Extra config options passed to econf, similar to EXTRA_ECONF.

case ${EAPI:-0} in
	4|5) ;;
	*) die "this eclass doesn't support < EAPI 4" ;;
esac

if [[ -f "${FILESDIR}"/${P}_fix-build-system.patch ]]; then
	AUTOTOOLS_AUTORECONF=1
	AUTOTOOLS_IN_SOURCE_BUILD=1
fi

inherit autotools-utils eutils flag-o-matic

HOMEPAGE="http://emboss.sourceforge.net/"
LICENSE="LGPL-2 GPL-2"

SLOT="0"
IUSE="mysql pdf png postgres static-libs X"

DEPEND="
	dev-libs/expat
	dev-libs/libpcre:3
	sci-libs/plplot
	sys-libs/zlib
	mysql? ( dev-db/mysql )
	pdf? ( media-libs/libharu )
	png? ( media-libs/gd[png] )
	postgres? ( dev-db/postgresql )
	X? ( x11-libs/libXt )"
RDEPEND="${DEPEND}"

if [[ ${PN} == embassy-* ]]; then
	EMBASSY_PACKAGE=yes
	# The EMBASSY package name, retrieved from the inheriting ebuild's name
	EN=${PN:8}
	# The full name and version of the EMBASSY package (excluding the Gentoo
	# revision number)
	EF=$(echo ${EN} | tr "[:lower:]" "[:upper:]")-${PV}
	: ${EBO_DESCRIPTION:=${EN}}
	DESCRIPTION="EMBOSS integrated version of ${EBO_DESCRIPTION}"
	SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/${EF}.tar.gz -> embassy-${EN}-${PVR}.tar.gz"
	DEPEND+=" >=sci-biology/emboss-6.3.1_p4[mysql=,pdf=,png=,postgres=,static-libs=,X=]"

	S="${WORKDIR}"/${EF}
fi

DOCS=()
#DOCS="AUTHORS ChangeLog NEWS README"

# @FUNCTION: emboss_src_prepare
# @DESCRIPTION:
# Does following things
#
#  1. Patches with "${FILESDIR}"/${PF}.patch, if present
#  2. Runs eautoreconf, unless EBO_EAUTORECONF is set to no
#

emboss_src_prepare() {
	if [[ -f "${FILESDIR}"/${P}_fix-build-system.patch ]]; then
		mv configure.{in,ac} || die
		epatch "${FILESDIR}"/${P}_fix-build-system.patch
	fi

	[[ -n ${EBO_PATCH} ]] && epatch "${WORKDIR}"/${P}-upstream.patch
	[[ -f ${FILESDIR}/${PF}.patch ]] && epatch "${FILESDIR}"/${PF}.patch

	autotools-utils_src_prepare
}

# @FUNCTION: emboss_src_configure
# @DESCRIPTION:
# runs econf with following options.
#
#  $(use_with X x)
#  $(use_with png pngdriver)
#  $(use_with pdf hpdf)
#  $(use_with mysql mysql)
#  $(use_with postgres postgresql)
#  $(use_enable static-libs static)
#  --enable-large
#  --without-java
#  --enable-systemlibs
#  --docdir="${EPREFIX}/usr/share/doc/${PF}"
#  ${EBO_EXTRA_ECONF}

emboss_src_configure() {
	local myeconfargs=(
		$(use_with X x)
		$(use_with png pngdriver "${EPREFIX}/usr")
		$(use_with pdf hpdf "${EPREFIX}/usr")
		$(use_with mysql mysql "${EPREFIX}/usr/bin/mysql_config")
		$(use_with postgres postgresql "${EPREFIX}/usr/bin/pg_config")
		$(use_enable static-libs static)
		--enable-large
		--without-java
		--enable-systemlibs
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		${EBO_EXTRA_ECONF}
	)

	if [[ ${EMBASSY_PACKAGE} == yes ]]; then
		append-cppflags "-I${EPREFIX}/usr/include/emboss"
	fi

	autotools-utils_src_configure
}

EXPORT_FUNCTIONS src_prepare src_configure
