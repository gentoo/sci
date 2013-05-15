# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils flag-o-matic multilib

MY_PV=${PV}

DESCRIPTION="research tool for polyhedral geometry and combinatorics"
SRC_URI="http://polymake.org/lib/exe/fetch.php/download/${PN}-${MY_PV}.tar.bz2"
HOMEPAGE="http://polymake.org"

IUSE="libpolymake"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="dev-libs/gmp
	dev-libs/boost
	dev-libs/libxml2:2
	dev-perl/XML-LibXML
	dev-libs/libxslt
	dev-perl/XML-LibXSLT
	dev-perl/XML-Writer
	dev-perl/Term-ReadLine-Gnu"
RDEPEND="${DEPEND}"

src_prepare() {
	# embedded jreality is a precompiled desaster (bug #346073)
	epatch "${FILESDIR}/${P}"-drop-jreality.patch
	# Assign a soname
	epatch "${FILESDIR}/2.10"-soname.patch
	rm -rf java_build/jreality

	# Don't strip
	sed -i '/system "strip $to"/d' support/install.pl || die

	einfo "During compile this package uses up to"
	einfo "750MB of RAM per process. Use MAKEOPTS=\"-j1\" if"
	einfo "you run into trouble."
}

src_configure () {
	export CXXOPT=$(get-flag -O)
	local myconf
	if use libpolymake ; then
		# WTF: If we leave myconf as the empty string here
		# then configure will fail.
		myconf="--without-prereq"
	else
		# --with-callable is not supported :(
		myconf="--without-callable"
	fi
	echo ${myconf}
	# Configure does not accept --host, therefore econf cannot be used
	./configure --prefix="${EPREFIX}/usr" \
		--without-java \
		--without-prereq \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--libexecdir="${EPREFIX}/usr/$(get_libdir)/polymake" \
		"${myconf}" || die
}

src_install(){
	emake -j1 DESTDIR="${D}" install || die "install failed"
}

pkg_postinst(){
	elog "Polymake uses Perl Modules compiled during install."
	elog "You have to reinstall polymake after an upgrade of Perl."
	elog " "
	elog "This version of polymake does not ship docs. Sorry."
	elog "Help can be found on http://www.opt.tu-darmstadt.de/polymake_doku/ "
	elog " "
	elog "Visualization in polymake is via jreality which ships pre-compiled"
	elog "binary libraries.  Until this situation is resolved, support for"
	elog "jreality has been dropped.  Please contribute to Bug #346073 to "
	elog "make jreality available in Gentoo."
}
