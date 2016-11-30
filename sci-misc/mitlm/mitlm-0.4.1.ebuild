# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools

DESCRIPTION="A set of tools designed for the efficient estimation of statistical n-gram language models"
HOMEPAGE="https://github.com/mitlm/mitlm"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${PN}_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	echo "m4_ifdef([AM_PROG_AR], [AM_PROG_AR])" >> configure.ac
	eautoreconf
}
