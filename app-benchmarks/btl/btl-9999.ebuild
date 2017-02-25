# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mercurial

DESCRIPTION="Bench Template Library"
HOMEPAGE="https://bitbucket.org/spiros/btl"
EHG_REPO_URI="https://bitbucket.org/spiros/btl"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

src_install() {
	insinto /usr/include/btl
	doins -r *
}
