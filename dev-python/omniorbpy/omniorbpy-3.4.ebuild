# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit autotools-utils eutils multilib python-r1

MY_P=${P/omniorb/omniORB}

DESCRIPTION="A robust high-performance CORBA ORB for Python"
HOMEPAGE="http://omniorb.sourceforge.net/"
SRC_URI="mirror://sourceforge/omniorb/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="ssl"

DEPEND="
	>=net-misc/omniORB-4.1.3
	ssl? ( dev-libs/openssl )"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed \
		-e "s/^CXXDEBUGFLAGS.*/CXXDEBUGFLAGS = ${CXXFLAGS}/" \
		-e "s/^CDEBUGFLAGS.*/CDEBUGFLAGS = ${CFLAGS}/" \
		-e "s/'prefix[\t ]*:= \/usr'/'prefix := \${DESTDIR}\/usr'/" \
		-i "${S}"/mk/beforeauto.mk.in || die
	sed \
		-e 's#^.*compileall[^\\]*#${EPREFIX}/bin/true;#' \
		-i "${S}"/python/dir.mk \
		"${S}"/python/omniORB/dir.mk \
		"${S}"/python/COS/dir.mk \
		"${S}"/python/CosNaming/dir.mk || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=( --with-omniorb="${EPREFIX}/usr" )

	use ssl && myconf+=( --with-openssl="${EPREFIX}/usr" )

	python_foreach_impl autotools-utils_src_configure
}

src_compile() {
	python_foreach_impl autotools-utils_src_compile
}

src_install() {
	python_foreach_impl autotools-utils_src_install

	dohtml -r doc/omniORBpy
	dodoc doc/omniORBpy.p*
	dodoc doc/tex/*

	insinto /usr/share/doc/${PF}/
	doins -r examples || die
}
