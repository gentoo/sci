# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A tool to estimate, store, and access very large n-gram language models"
HOMEPAGE="https://hlt-mt.fbk.eu/technologies/irstlm"
SRC_URI="https://github.com/irstlm-team/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	eautoreconf
	eapply_user
}
