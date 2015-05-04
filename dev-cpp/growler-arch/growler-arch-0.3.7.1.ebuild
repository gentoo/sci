# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="NOSA"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Growler-Arch are growler libraries and utilities."
HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"
SRC_URI="${HOMEPAGE}/downloads/growler-arch-${PV}.tar.gz"

IUSE="doc static"

RDEPEND=">=dev-cpp/growler-link-0.3.7
		 >=dev-cpp/growler-thread-0.3.4
		 >=dev-cpp/growler-core-0.3.7"

DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen dev-libs/libxslt )"

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
