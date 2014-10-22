# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools

DESCRIPTION="A tool for the estimation, representation, and computation of statistical language models"
HOMEPAGE="https://hlt.fbk.eu/technologies/irstlm"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${P}/trunk"

src_prepare() {
	eautoreconf
}
