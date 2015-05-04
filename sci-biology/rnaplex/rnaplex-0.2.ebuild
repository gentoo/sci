# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MY_P=RNAplex-${PV}

DESCRIPTION="RNA-RNA interaction search"
HOMEPAGE="http://www.tbi.univie.ac.at/~htafer/"
SRC_URI="http://www.tbi.univie.ac.at/~htafer/RNAplex/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""
S=${WORKDIR}/${MY_P}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
