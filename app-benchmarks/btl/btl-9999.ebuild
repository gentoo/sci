# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit mercurial

DESCRIPTION="Bench Template Library"
HOMEPAGE="https://bitbucket.org/spiros/btl"
EHG_REPO_URI="https://bitbucket.org/spiros/btl"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=""

src_install() {
	insinto /usr/include/btl
	doins -r *
}