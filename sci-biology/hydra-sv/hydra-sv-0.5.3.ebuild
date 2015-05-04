# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/mosaik/mosaik-1.0.1388.ebuild,v 1.1 2010/04/11 17:29:40 weaver Exp $

EAPI=5

DESCRIPTION="Detection of structural variation breakpoints in unique and duplicated genomic regions"
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
