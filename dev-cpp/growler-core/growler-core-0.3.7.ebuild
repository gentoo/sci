# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /CVS/groups/vistech/bgreen-overlay/dev-cpp/growler-core/growler-core-0.3.1.ebuild,v 1.1.1.1 2007/10/12 20:18:26 bgreen Exp $

SLOT="0"
LICENSE="NOSA"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Growler-Core provides a large set of mainly general-purpose classes and functionality for developing and using the Growler Distributed Component Architecture."
HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"
SRC_URI="${HOMEPAGE}/downloads/growler-core-${PV}.tar.gz"

IUSE="doc static"

RDEPEND=">=dev-cpp/growler-link-0.3.7
		 >=dev-cpp/growler-thread-0.3.4"

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

