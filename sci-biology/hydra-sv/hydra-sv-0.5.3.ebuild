# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Detection of structural variation breakpoints"
HOMEPAGE="http://code.google.com/p/hydra-sv/"
SRC_URI="http://hydra-sv.googlecode.com/files/Hydra.v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/Hydra-Version-${PV}"

src_compile() {
	emake clean
	default
}

src_install() {
	dobin bin/* scripts/*
}
