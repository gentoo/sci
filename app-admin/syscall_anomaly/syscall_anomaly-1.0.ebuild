# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

EAPI="2"

DESCRIPTION="Anomaly detection on system call arguments"
HOMEPAGE="http://www.cs.ucsb.edu/~seclab/projects/libanomaly/index.html"
SRC_URI="http://www.cs.ucsb.edu/~seclab/projects/libanomaly/downloads/${P}.tar.gz"

LICENSE="GPL2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"	
IUSE=""

DEPEND="dev-libs/libanomaly"
RDEPEND="${DEPEND}"

src_prepare(){
	epatch "${FILESDIR}/${P}-gcc4_compat.patch"
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"
}

