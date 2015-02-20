# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit

DESCRIPTION="A terminfo parsing library"
HOMEPAGE="https://github.com/mauke/unibilium"
SRC_URI="https://github.com/mauke/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install
}
