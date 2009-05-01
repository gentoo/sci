# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Essential database for rosetta"
HOMEPAGE="www.rosettacommons.org"
SRC_URI="rosetta3_database.tgz"

LICENSE="|| ( rosetta-academic rosetta-commercial )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="fetch binchecks strip"

S="${WORKDIR}"/rosetta3_database

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and get ${A}"
	einfo "which must be placed in ${DISTDIR}"
}

src_install() {
	find . -type d -name ".svn" -exec rm -rf '{}' \; 2> /dev/null
	insinto /usr/share/${PN}
	doins -r * || die
}
