# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /CVS/groups/vistech/bgreen-overlay/dev-cpp/growler-math/growler-math-0.3.1.ebuild,v 1.1.1.1 2007/10/12 20:18:26 bgreen Exp $

SLOT="0"
LICENSE="NOSA"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Growler-Math provides a set of math-related classes and functionality"
HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"
SRC_URI="${HOMEPAGE}/downloads/growler-math-${PV}.tar.gz"

IUSE="static"

RDEPEND=">=dev-cpp/growler-core-0.3.7"

DEPEND="${RDEPEND}"

src_compile() {
	econf \
		$(use_enable static) \
		--enable-fast-install \
		|| die "could not configure"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README NEWS AUTHORS NOSA ChangeLog
}

