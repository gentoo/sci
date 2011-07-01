# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit eutils multilib python

MY_P=${P/omniorb/omniORB}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A robust high-performance CORBA ORB for Python."
HOMEPAGE="http://omniorb.sourceforge.net/"
SRC_URI="mirror://sourceforge/omniorb/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="ssl"

DEPEND=">=net-misc/omniORB-4.1.3
	ssl? ( dev-libs/openssl )"
RDEPEND=${DEPEND}

RESTRICT_PYTHON_ABIS="3.*"

src_prepare() {
	sed -i -e "s/^CXXDEBUGFLAGS.*/CXXDEBUGFLAGS = ${CXXFLAGS}/" \
		-e "s/^CDEBUGFLAGS.*/CDEBUGFLAGS = ${CFLAGS}/" \
		"${S}"/mk/beforeauto.mk.in
	sed -i -e 's#^.*compileall[^\\]*#${EPREFIX}/bin/true;#' \
		"${S}"/python/dir.mk \
		"${S}"/python/omniORB/dir.mk \
		"${S}"/python/COS/dir.mk \
		"${S}"/python/CosNaming/dir.mk
	python_copy_sources
}

src_configure() {
	configuration() {
		local myconf
		use ssl && myconf="${MY_CONF} --with-openssl=${EPREFIX}/usr"

		PYTHON="$(PYTHON)" econf --with-omniorb="${EPREFIX}"/usr ${myconf}
	}
	python_execute_function -s configuration
}

src_compile() {
	python_src_compile
}

src_install() {
	installation() {
		# make files are crap!
		sed -i -e "s/'prefix[\t ]*:= \/usr'/'prefix := \${DESTDIR}\/usr'/" \
			mk/beforeauto.mk

		# won't work without these really very ugly hack...
		# maybe someone can do better..

		mv python/omniORB/dir.mk python/omniORB/dir.mk_orig
		awk -v STR="ir\\\.idl" '{ if (/^[[:space:]]*$/) flag = 0; tmpstr = $0; if (gsub(STR, "", tmpstr)) flag = 1; if (flag) print "#" $0; else print $0; }' python/omniORB/dir.mk_orig > python/omniORB/dir.mk

		mv python/dir.mk python/dir.mk_orig
		awk -v STR="Naming\\\.idl" '{ if (/^[[:space:]]*$/) flag = 0; tmpstr = $0; if (gsub(STR, "", tmpstr)) flag = 1; if (flag) print "#" $0; else print $0; }' python/dir.mk_orig > python/dir.mk

		emake DESTDIR="${D}" install || die "install failed"

		# bug #166738
		mv "${ED}"$(python_get_sitedir)/PortableServer.py \
			"${ED}"$(python_get_sitedir)/omniorbpy_PortableServer.py

		mv "${ED}"$(python_get_sitedir)/CORBA.py \
			"${ED}"$(python_get_sitedir)/omniorbpy_CORBA.py

		rm "${ED}"$(python_get_sitedir)/omniidl_be/__init__.py*

		# fixed the file collision from bug #247851
		rm "${ED}"$(python_get_sitedir)/__init__.py
	}
	python_execute_function -s installation

	dodoc COPYING.LIB README.txt README.Python || die
	dohtml -r doc/omniORBpy || die
	dodoc doc/omniORBpy.p* || die # ps,pdf
	dodoc doc/tex/* || die # .bib, .tex

	insinto /usr/share/doc/${PF}/
	doins -r examples || die

}

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)
}

pkg_postrm() {
	python_mod_cleanup
}
