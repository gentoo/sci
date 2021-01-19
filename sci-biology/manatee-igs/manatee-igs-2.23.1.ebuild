# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="IGS-modified version of the genome annotation tool using Chado database schema"
HOMEPAGE="http://manatee.sourceforge.net/igs" # no https
SRC_URI="https://downloads.sourceforge.net/project/manatee/igs_manatee/${PV}/manatee-${PV}_linux.tgz"

LICENSE="Artistic-Manatee"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/expat-1.95.8
	>=media-libs/gd-2.0.34
	dev-perl/CGI
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
	dev-perl/Date-Manip
	dev-perl/IO-Tee
	dev-perl/MLDBM
	dev-perl/JSON
	dev-perl/JSON-Any
	sci-biology/bioperl"
RDEPEND="${DEPEND}
	>=virtual/mysql-5:*
	>=www-servers/apache-2.2"

S="${WORKDIR}/manatee-${PV}_linux"

src_prepare(){
	default
	find "${S}" -name \*.cgi | while read f; do sed -e 's|#!/usr/local/bin/perl|#!/usr/bin/perl|' -i $f; done
	find "${S}" -name \*.pl | while read f; do sed -e 's|#!/usr/local/bin/perl|#!/usr/bin/perl|' -i $f; done
	find "${S}" -name \*.pm | while read f; do sed -e 's|#!/usr/local/bin/perl|#!/usr/bin/perl|' -i $f; done
}

src_install(){
	dodir /var/www/localhost/cgi-bin
	cp -r src/cgi-bin/chado_prok_manatee "${D}"/var/www/localhost/cgi-bin
	dodir /var/www/localhost/htdocs/manatee
	cp -r src/htdocs/tdb "${D}"/var/www/localhost/htdocs/manatee

	einfo "Please read the "${S}"/databases/Makefile.PL and import the databases into your MySQL database"

	einfo "You have to fetch the 1.1 GB large file from https://sourceforge.net/projects/manatee/files/igs_manatee/"${PV}"/lookups-"${PV}"_linux.tgz"
	einfo "You need to update it regularly."
	einfo "Also fetch https://sourceforge.net/projects/manatee/files/igs_manatee/"${PV}"/blastdb-"${PV}".tgz (about 2MB in size)"
}
