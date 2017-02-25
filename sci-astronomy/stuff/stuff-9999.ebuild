# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit subversion

ESVN_REPO_URI="https://astromatic.net/pubsvn/software/${PN}/trunk"
ESVN_OPTIONS="--trust-server-cert-failures=unknown-ca"

SRC_URI=""
KEYWORDS=""

DESCRIPTION="Tool for automatic generation of astronomical catalogs"
HOMEPAGE="http://www.astromatic.net/software/stuff/"

LICENSE="GPL-3"
SLOT="0"
IUSE="threads"

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	default
	subversion_src_prepare
}

src_configure() {
	econf $(use_enable threads)
}
