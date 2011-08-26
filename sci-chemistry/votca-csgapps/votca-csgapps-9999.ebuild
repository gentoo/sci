# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/votca-csgapps/votca-csgapps-1.2.1.ebuild,v 1.1 2011/08/25 20:42:53 ottxor Exp $

EAPI=4

inherit cmake-utils

if [ "${PV}" != "9999" ]; then
	SRC_URI="http://votca.googlecode.com/files/${PF}.tar.gz"
	RESTRICT="primaryuri"
else
	inherit mercurial
	EHG_REPO_URI="https://csgapps.votca.googlecode.com/hg"
	S="${WORKDIR}/${EHG_REPO_URI##*/}"
fi

DESCRIPTION="Extra applications for votca-csg"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="=sci-chemistry/${PN%apps}-${PV}"

DEPEND="${RDEPEND}"

DOCS=( README )
