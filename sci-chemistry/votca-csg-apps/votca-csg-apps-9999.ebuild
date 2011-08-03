# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils mercurial

EHG_REPO_URI="https://csgapps.votca.googlecode.com/hg"
S="${WORKDIR}/${EHG_REPO_URI##*/}"

DESCRIPTION="Tutorials for votca-csg"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="=sci-chemistry/${PN%-apps}-${PV}"

DEPEND="${RDEPEND}"

DOCS=( README )
