# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="library for Levenberg-Marquardt least-squares minimization and curve fitting"
HOMEPAGE="http://apps.jcns.fz-juelich.de/doku/sc/lmfit"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
