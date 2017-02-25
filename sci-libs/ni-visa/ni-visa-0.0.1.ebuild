# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Placeholder for an NI-VISA library ebuild"
HOMEPAGE="http://www.ni.com/"
SRC_URI="NI-VISA-0.0.1.iso"

LICENSE="ni-visa"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
SLOT="0"

RESTRICT="fetch"

src_install() {
	insinto /etc/revdep-rebuild
	doins "${FILESDIR}/70nivisa"
}

pkg_nofetch() {
	elog Please download the NI-VISA library for linux from
	elog    http://joule.ni.com/nidu/cds/view/p/id/2044/lang/en
	elog and install it.
	elog Afterwards run the command "echo > /usr/portage/distfiles/NI-VISA-0.0.1.iso"
	echo
	elog Yes I know this is an ugly hack but the NI installer is even uglier...
	elog See for more information http://decibel.ni.com/content/message/16917
}
