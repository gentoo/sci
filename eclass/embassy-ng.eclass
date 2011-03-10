# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/embassy.eclass,v 1.17 2008/11/03 22:17:50 ribosome Exp $

# Creator of the original eclass
# Author Olivier Fisette <ofisette@gmail.com>
#
# Author of the next generation eclass
# Justin Lecher <jlec@gentoo.org>

# @ECLASS: embassy-ng.eclass
# @MAINTAINER:
# sci-biology@gentoo.org
# jlec@gentoo.org
# @BLURB: Use this to easy install EMBOSS and EMBASSY programs (EMBOSS add-ons).
# @DESCRIPTION:
# The inheriting ebuild should provide EBOV, EBO_DESCRIPTION and "KEYWORDS",
# before the inherit line.
# Additionally "(R|P)DEPEND"encies and other standard ebuild Variables can be set.
# The inheriting ebuild's name must begin by "embassy-" and must be EAPI=4 conform.

# @ECLASS-VARIABLE: EBOV
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# This specifies the minimum Emboss version needed for this package. *DEPEND are set to
# >=sci-biology/emboss-${EBOV}.
# This variable must be always set by the ebuild before the inheriting line

# @ECLASS-VARIABLE: EBO_DESCRIPTION
# @DESCRIPTION:
# Should be set. Completes the describtion of the embassy module as follows:
#
# EMBOSS integrated version of EBO_DESCRIPTION"
#
# Defaults to the upstream name of the module.

# @ECLASS-VARIABLE: EBO_PATCH
# @DEFAULT_UNSET
# @DESCRIPTION: Specify the patch level of EMBOSS. Only available for the emboss ebuild.
# The patch wil be fetch from:
#
# ftp://emboss.open-bio.org/pub/EMBOSS/fixes/patches/patch-1-${EBO_PATCH}.gz.
#
# Embassy package should create one patch package and place it in FILESDIR, e.g.
# "files/embassy-iprscan-4.3.1-r2.patch". The patch will be automatically used during src_prepare

# @ECLASS-VARIABLE: NO_RECONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this, if you do want to have eautoreconf be run after patching.

# @ECLASS-VARIABLE: EBO_ECONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Extra config options passed to econf, similar to EXTRA_ECONF.

EAPI="4"

inherit autotools eutils multilib

DESCRIPTION="Based on the $ECLASS eclass"
HOMEPAGE="http://emboss.sourceforge.net/"
LICENSE="LGPL-2 GPL-2"

SLOT="0"
IUSE+=" doc minimal mysql pdf png postgres static-libs X"

DEPEND="
	dev-libs/expat
	dev-libs/libpcre:3
	sci-libs/plplot
	sys-libs/zlib
	mysql? ( dev-db/mysql )
	pdf? ( media-libs/libharu )
	png? (
		sys-libs/zlib
		media-libs/libpng
		media-libs/gd
		)
	postgres? ( dev-db/postgresql-base )
	X? ( x11-libs/libXt )"

RDEPEND="${DEPEND}"

if [[ ${PN} == "emboss" ]] ; then
	DESCRIPTION="The European Molecular Biology Open Software Suite - A sequence analysis package"
	SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-${EBOV}.tar.gz"
	[[ -n ${EBO_PATCH} ]] && SRC_URI+=" ftp://${PN}.open-bio.org/pub/EMBOSS/fixes/patches/patch-1-${EBO_PATCH}.gz -> ${P}.patch.gz"
	IUSE+=" minimal"
	RDEPEND+=" !sys-devel/cons"
	PDEPEND="
		!minimal? (
				sci-biology/aaindex
				sci-biology/cutg
				sci-biology/prints
				sci-biology/prosite
				sci-biology/rebase
				sci-biology/transfac
				)"
	S="${WORKDIR}/EMBOSS-${EBOV}"
else
	# The EMBASSY package name, retrieved from the inheriting ebuild's name
	EN=${PN:8}
	# The full name and version of the EMBASSY package (excluding the Gentoo
	# revision number)
	EF="$(echo ${EN} | tr "[:lower:]" "[:upper:]")-${PV}"
	EBO_DESCRIPTION=${EBO_DESCRIPTION:=${EN}}
	DESCRIPTION="EMBOSS integrated version of ${EBO_DESCRIPTION}"
	SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/${EF}.tar.gz -> embassy-${EBOV}-${PN:8}-${PV}.tar.gz"
	DEPEND+=" >=sci-biology/emboss-${EBOV}[mysql=,pdf=,png=,postgres=,static-libs=,X=]"

	S="${WORKDIR}"/${EF}
fi

# @FUNCTION: embassy-ng_src_prepare
# @USAGE:
# @RETURN:
# @MAINTAINER:
# @DESCRIPTION:
# Does three things
#
#  1. Patches EMBOSS if EBO_PATCH is set
#  2. Patches, if "${FILESDIR}"/${PF}.patch is a file
#  3. runs eautoreconf unless NO_RECONF is set
#

embassy-ng_src_prepare() {
	[[ ${PN} == emboss ]] && [[ -n ${EBO_PATCH} ]] && epatch "${WORKDIR}"/${P}.patch
	[[ -f "${FILESDIR}"/${PF}.patch ]] && epatch "${FILESDIR}"/${PF}.patch
	[[ -n ${NO_RECONF} ]] || eautoreconf
}

# @FUNCTION: embassy-ng_src_prepare
# @USAGE:
# @RETURN:
# @MAINTAINER:
# @DESCRIPTION:
# runs econf with following options. Extra things can be passed by setting EBO_ECONF
#
#  $(use_with X x)
#  $(use_with png pngdriver "${EPREFIX}/usr")
#  $(use_with doc docroot "${EPREFIX}/usr")
#  $(use_with pdf hpdf "${EPREFIX}/usr")
#  $(use_with mysql mysql "${EPREFIX}/usr/bin/mysql_config")
#  $(use_with postgres postgresql "${EPREFIX}/usr/bin/pg_config")
#  $(use_enable amd64 64)
#  $(use_enable static-libs static)
#  --enable-large
#  --without-java
#  --enable-systemlibs
#  ${EBO_ECONF}

embassy-ng_src_configure() {
	econf \
		$(use_with X x) \
		$(use_with png pngdriver "${EPREFIX}/usr") \
		$(use_with doc docroot "${EPREFIX}/usr") \
		$(use_with pdf hpdf "${EPREFIX}/usr") \
		$(use_with mysql mysql "${EPREFIX}/usr/bin/mysql_config") \
		$(use_with postgres postgresql "${EPREFIX}/usr/bin/pg_config") \
		$(use_enable amd64 64) \
		$(use_enable static-libs static) \
		--enable-large \
		--without-java \
		--enable-systemlibs \
		${EBO_ECONF}
}

embassy-ng_src_install() {
	emake DESTDIR="${D}" install
	nonfatal dodoc AUTHORS ChangeLog FAQ NEWS README THANKS
}

EXPORT_FUNCTIONS src_prepare src_configure src_install
