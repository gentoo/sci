# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == "9999" ]] ; then
	inherit subversion
	ESVN_REPO_URI="https://astromatic.net/pubsvn/software/${PN}/trunk"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

#AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils

DESCRIPTION="Combine weight maps and polygon for astronomical images weighting"
HOMEPAGE="http://www.astromatic.net/software/weightwatcher/"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}"

src_install () {
	autotools-utils_src_install
	use doc && dodoc doc/*
}
