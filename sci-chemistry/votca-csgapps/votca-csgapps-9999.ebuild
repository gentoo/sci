# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils

if [ "${PV}" != "9999" ]; then
	SRC_URI="http://downloads.votca.googlecode.com/hg/${PF}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
else
	inherit mercurial
	EHG_REPO_URI="https://code.google.com/p/votca.csgapps/"
	KEYWORDS=""
fi

DESCRIPTION="Extra applications for votca-csg"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="=sci-chemistry/${PN%apps}-${PV}"

DEPEND="${RDEPEND}"

DOCS=( README )
