# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/ssm/ssm-1.1.ebuild,v 1.7 2012/05/21 19:14:47 ranger Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="A macromolecular coordinate superposition library"
HOMEPAGE="https://launchpad.net/ssm"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+ccp4 static-libs"

DEPEND="
	>=sci-libs/mmdb-1.23
	ccp4? ( sci-libs/libccp4 )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-pc.patch )

src_configure() {
	local myeconfargs=( $(use_enable ccp4) )
	autotools-utils_src_configure
}
