# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="IGS-modified version of the genome annotation tool using Chado database schema"
HOMEPAGE="http://manatee.sourceforge.net/igs"
SRC_URI="http://sourceforge.net/projects/manatee/files/igs_manatee/"${PV}"/manatee-"${PV}"_linux.tgz
		http://manatee.sourceforge.net/igs/docs/README_Linux.txt"

LICENSE="Artistic-Manatee"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
		>=dev-libs/expat-1.95.8
		>=media-libs/gd-2.0.34
		virtual/perl-CGI
		dev-perl/Bio-DB-Das-Chado
		dev-perl/DBI
		dev-perl/DBD-mysql
		dev-perl/XML-Parser
		dev-perl/XML-Twig
		dev-perl/XML-Simple
		dev-perl/XML-Writer
		dev-perl/HTML-Template
		dev-perl/Tree-DAG_Node
		virtual/perl-File-Spec
		virtual/perl-Data-Dumper
		dev-perl/GD
		dev-perl/GDTextUtil
		dev-perl/GDGraph
		virtual/perl-Storable
		dev-perl/Log-Log4perl
		dev-perl/Log-Cabin
		dev-perl/DateManip
		dev-perl/IO-Tee
		dev-perl/MLDBM
		dev-perl/JSON
		dev-perl/JSON-Any
		sci-biology/bioperl"
RDEPEND="${DEPEND}
		>=dev-db/mysql-5.0
		>=www-servers/apache-2.2"

S="${WORKDIR}"/manatee-"${PV}"_linux

src_prepare(){
	find "${S}" -name \*.cgi | while read f; do sed -e 's|#!/usr/local/bin/perl|#!/usr/bin/perl|' -i $f; done
	find "${S}" -name \*.pl | while read f; do sed -e 's|#!/usr/local/bin/perl|#!/usr/bin/perl|' -i $f; done
	find "${S}" -name \*.pm | while read f; do sed -e 's|#!/usr/local/bin/perl|#!/usr/bin/perl|' -i $f; done
}

#src_configure(){
#	there used to be manateee-="${PV}".tgz file which contained configure script in the past
#	now the layout is different, temporarily commenting out untill we find the current full sources back again
#	econf HTTPD=/usr/sbin/httpd HTTPD_SCRIPT_HOME=/var/www/cgi-bin HTTPD_DOC_HOME=/var/www/htdocs MYSQLD=/usr/sbin/mysqld || die
#}
#
#src_compile(){
#	emake || die
#}

src_install(){
	dodoc ${DISTDIR}"/README_Linux.txt"
	dodir /var/www/localhost/cgi-bin
	cp -r src/cgi-bin/chado_prok_manatee "${D}"/var/www/localhost/cgi-bin
	dodir /var/www/localhost/htdocs/manatee
	cp -r src/htdocs/tdb "${D}"/var/www/localhost/htdocs/manatee

	einfo "Please read the "${S}"/databases/Makefile.PL and import the databases into your MySQL database"

	einfo "You have to fetch the 1.1 GB large file from http://sourceforge.net/projects/manatee/files/igs_manatee/"${PV}"/lookups-"${PV}"_linux.tgz"
	einfo "You need to update it regularly."
	einfo "Also fetch http://sourceforge.net/projects/manatee/files/igs_manatee/"${PV}"/blastdb-"${PV}".tgz (about 2MB in size)"
}
