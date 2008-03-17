# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/generic-genome-browser/generic-genome-browser-1.58.ebuild,v 1.9 2007/07/29 17:07:38 phreak Exp $

inherit perl-app

MY_PN="Generic-Genome-Browser"

# I don't know if the '--' is a typo... TODO contact somebody and find out.
MY_P="${MY_PN}--${PV}"

DESCRIPTION="The generic genome browser provides a display of genomic annotations on interactive web pages"
HOMEPAGE="http://www.gmod.org"
SRC_URI="mirror://sourceforge/gmod/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="mysql gd"

S="${WORKDIR}/${MY_PN}-${PV}"

DEPEND="
	>=sci-biology/bioperl-1.4
	>=virtual/perl-CGI-2.56
	>=dev-perl/GD-2.07
	dev-perl/DBI
	virtual/perl-Digest-MD5
	dev-perl/Text-Shellwords
	dev-perl/libwww-perl
	dev-perl/XML-Parser
	dev-perl/XML-Writer
	dev-perl/XML-Twig
	dev-perl/XML-DOM
	dev-perl/Bio-Das
	gd? (
			dev-perl/GD-SVG
		)
	mysql?
		(
			>=virtual/mysql-4.0
			dev-perl/DBD-mysql
		)
	>=www-servers/apache-2.0.47"

RDEPEND="${DEPEND}"

src_compile() {

	cd ${S}
#	ewarn "Modifying Makefile.PL to avoid sandbox violation"
	sed -e "s:WriteMakefile(:WriteMakefile(\n 'PREFIX'=>'${D}/usr',\n'INSTALLDIRS'  => 'vendor',:" -i Makefile.PL \
		|| die "Failed to sed Makefile.PL"

	perl Makefile.PL \
			HTDOCS=/var/www/localhost/htdocs \
			CGIBIN=/var/www/localhost/cgi-bin \
			CONF=/etc \
			PREFIX=/var/www/localhost \
			DESTDIR=${D} \
			INSTALLDIRS=vendor
	#perl-module_src_compile || die "Make failed"
	perl-module_src_test || die "Test Failed"
}

# Might want to look at how to use webapp with this.

src_install() {
	dodir /etc
	dodir /var/www/localhost/htdocs
	dodir /var/www/localhost/cgi-bin
	mydoc="History README TODO INSTALL"
	dodir /usr/share/${PF}/tutorial
	cd ${S}/docs/tutorial
	tar cf - ./ | ( cd ${D}/usr/share/${PF}/scripts; tar xf -)
	cd ${S}
	sed -e "s:my \$dir = \":my \$dir = \"${D}/:" -i install_util/conf_install.PLS || die "sed1 failed"
	sed -e "s:my \$ht_target = \":my \$ht_target = \"${D}/:" -i install_util/htdocs_install.PLS || die "sed2 failed"
	sed -e "s:my \$cgi_target = :my \$cgi_target = \"${D}\"\.:" -i install_util/cgi_install.PLS || die "sed3 failed"

	perl-module_src_install
}
