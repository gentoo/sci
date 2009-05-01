# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python API fir swish-e"
HOMEPAGE="http://jibe.freeshell.org/bits/SwishE/"
SRC_URI="http://jibe.freeshell.org/bits/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=www-apps/swish-e-2.4"
DEPEND="${RDEPEND}"


