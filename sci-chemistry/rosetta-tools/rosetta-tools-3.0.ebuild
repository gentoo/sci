# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="BioTools"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Additional scripts for rosetta"
HOMEPAGE="http://www.rosettacommons.org/ http://dylans-biotools.sourceforge.net/"
SRC_URI="${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="fetch"

RDEPEND="dev-lang/perl"

S="${WORKDIR}/${MY_PN}"

src_install() {
	for x in $(ls *.pl); do
		newbin ${x} ${x%.pl} || die "failed to install ${x}"
	done
}
