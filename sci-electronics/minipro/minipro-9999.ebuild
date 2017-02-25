# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 git-r3 udev

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
	dobin ${PN}{,-query-db,hex}
	udev_dorules udev/rules.d/80-${PN}.rules
	doman man/${PN}.1
	dobashcomp bash_completion.d/${PN}
	bashcomp_alias ${PN} ${PN}-query-db
}
