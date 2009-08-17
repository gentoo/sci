# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="General purpose multiple alignment program for DNA and proteins"
HOMEPAGE="http://www.clustal.org/"
SRC_URI="http://www.clustal.org/download/current/${P}.tar.gz"

LICENSE="clustalw"
SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE=""

src_install() {
	einstall || die "Installation failed."
}
