# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Condor's classified advertisement language"
HOMEPAGE="http://www.cs.wisc.edu/condor/classad"
SRC_URI="ftp://ftp.cs.wisc.edu/condor/classad/c++/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pcre"

RDEPEND="pcre? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--enable-namespace \
		--enable-flexible-member
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README CHANGELOG NOTICE.txt
}
