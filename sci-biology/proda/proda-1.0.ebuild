# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="Multiple alignment of protein sequences with repeated and shuffled elements"
HOMEPAGE="http://proda.stanford.edu/"
SRC_URI="http://proda.stanford.edu/proda_${MY_PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	sed -i -e 's/^\(CXXFLAGS =\)/#\1/' \
		-e 's/#CXXFLAGS = \(-O3.*$(OTHERFLAGS) -funroll-loops\)/CXXFLAGS := ${CXXFLAGS} \1/' \
		"${S}/Makefile" || die "sed failed"
}

src_install() {
	dobin proda
}
