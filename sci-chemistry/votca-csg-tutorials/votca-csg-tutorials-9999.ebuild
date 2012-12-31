# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit mercurial

EHG_REPO_URI="https://code.google.com/p/votca.csg-tutorials"

DESCRIPTION="Tutorials for votca-csg"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
IUSE=""

RDEPEND="=sci-chemistry/${PN%-tutorials}-${PV}"

DEPEND=""

src_install() {
	insinto /usr/share/doc/${PN%-tutorials}-${PV}/tutorials
	docompress -x /usr/share/doc/${PN%-tutorials}-${PV}/tutorials
	doins -r *
}
