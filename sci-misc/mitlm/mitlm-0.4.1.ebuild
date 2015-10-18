# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools

DESCRIPTION="A set of tools designed for the efficient estimation of statistical n-gram language models"
HOMEPAGE="https://code.google.com/p/mitlm/"
SRC_URI="https://mitlm.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	echo "m4_ifdef([AM_PROG_AR], [AM_PROG_AR])" >> configure.ac
	eautoreconf
}
