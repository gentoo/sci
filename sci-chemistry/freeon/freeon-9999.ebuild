# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils git-2

DESCRIPTION="FreeON is an experimental, open source (GPL) suite of programs for linear scaling quantum chemistry."
HOMEPAGE="http://www.freeon.org"

EGIT_REPO_URI="http://git.savannah.gnu.org/r/freeon.git"

AUTOTOOLS_AUTORECONF=1

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		--enable-internal_lapack
		--enable-internal_hdf5
	)
	autotools-utils_src_configure
}
