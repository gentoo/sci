# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="NOSA"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Growler-Thread is a pthread wrapper library."
HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"
SRC_URI="${HOMEPAGE}/downloads/growler-thread-${PV}.tar.gz"

IUSE="doc static"

RDEPEND=">=dev-cpp/growler-link-0.3.7"

DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen )"

src_compile() {
	econf \
		$(use_enable doc) \
		$(use_enable static) \
		--enable-fast-install \
		|| die "could not configure"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README NEWS AUTHORS NOSA ChangeLog
}
