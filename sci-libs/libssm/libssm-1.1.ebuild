# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils

MY_PN="${PN#lib}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A macromolecular coordinate superposition library"
HOMEPAGE="https://launchpad.net/ssm"
SRC_URI="http://launchpad.net/ssm/trunk/${PV}/+download/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=">=sci-libs/mmdb-1.23"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-mmdb.patch \
		"${FILESDIR}"/${P}-pc.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}
