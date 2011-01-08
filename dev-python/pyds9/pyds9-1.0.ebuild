# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit distutils

DESCRIPTION="Python wrapper around SAOImage DS9"
HOMEPAGE="http://hea-www.harvard.edu/saord/ds9/pyds9/"
SRC_URI="http://hea-www.harvard.edu/saord/download/ds9/python/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/xpa"
DEPEND="${RDEPEND}"
