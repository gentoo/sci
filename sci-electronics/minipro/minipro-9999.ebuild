# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit bash-completion-r1 eutils git-2

DESCRIPTION="A free and open TL866XX programmer"
HOMEPAGE="https://github.com/vdudouyt/minipro"
EGIT_REPO_URI="https://github.com/vdudouyt/minipro.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"

src_install() {
	dobin minipro
	dobin minipro-query-db
	dobin miniprohex
	insinto /lib/udev/rules.d
	doins udev/rules.d/80-minipro.rules
	doman man/minipro.1
	dobashcomp bash_completion.d/minipro
	bashcomp_alias minipro minipro-query-db
}
