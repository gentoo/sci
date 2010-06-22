# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Placeholder for an NI-VISA library ebuild"

#
# I'm working on a set of real ebuilds for the components of the NI-VISA package.
# However, this will take quite some time still. For the moment this file is a
# placeholder so dependencies can be fulfilled... (And yes I know this is evil.)
#   - dilfridge
#

SRC_URI="NI-VISA-0.0.1.iso"
HOMEPAGE="http://www.ni.com/"
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
	elog
	elog Please download the NI-VISA library for linux from
	elog    http://joule.ni.com/nidu/cds/view/p/id/2044/lang/en
	elog and install it.
	elog Afterwards run the command "echo > /usr/portage/distfiles/NI-VISA-0.0.1.iso"
	elog
	elog Yes I know this is an ugly hack but the NI installer is even uglier...
	elog See for more information http://decibel.ni.com/content/message/16917
	elog
}
