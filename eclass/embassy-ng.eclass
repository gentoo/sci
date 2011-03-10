# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/embassy.eclass,v 1.17 2008/11/03 22:17:50 ribosome Exp $

# Creator of the original eclass
# Author Olivier Fisette <ofisette@gmail.com>
#
# Author of the next generation eclass
# Justin Lecher <jlec@gentoo.org>

# @ECLASS: versionator.eclass
# @MAINTAINER:
# sci-biology@gentoo.org
# jlec@gentoo.org
# @BLURB: Use this to easy install EMBASSY programs (EMBOSS add-ons).
# @DESCRIPTION: The inheriting ebuild should provide a "DESCRIPTION", "KEYWORDS"
# and, if necessary, add "(R|P)DEPEND"encies. Additionnaly, the inheriting
# ebuild's name must begin by "embassy-". Also, before inheriting, the ebuild
# should specify what version of EMBOSS is required by setting EBOV.

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
	[[ -n ${EBO_PATCH} ]] && SRC_URI+=" ftp://${PN}.open-bio.org/pub/EMBOSS/fixes/patches/patch-1-${MY_PATCH}.gz -> ${P}.patch.gz"
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

	DESCRIPTION="EMBOSS integrated version of ${EBO_DESCRIPTION}"
	SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/${EF}.tar.gz -> embassy-${EBOV}-${PN:8}-${PV}.tar.gz"
	DEPEND+=" =sci-biology/emboss-${EBOV}*[mysql=,pdf=,png=,postgres=,static-libs=,X=]"

	S="${WORKDIR}"/${EF}
fi

embassy-ng_src_prepare() {
	[[ -n ${EBO_PATCH} ]] && epatch "${WORKDIR}"/${P}.patch
	[[ -f "${FILESDIR}"/${PF}.patch ]] && epatch "${FILESDIR}"/${PF}.patch
	[[ -n ${NO_RECONF} ]] || eautoreconf
}

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
		--enable-large
		--without-java \
		--enable-systemlibs \
		${EBO_ECONF}
}

embassy-ng_src_install() {
	emake DESTDIR="${D}" install
	nonfatal dodoc AUTHORS ChangeLog FAQ NEWS README THANKS
}

EXPORT_FUNCTIONS src_prepare src_configure src_install
