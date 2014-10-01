# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="genome annotation tool: view, modify, and store annotation for prokaryotic and eukaryotic genomes."
HOMEPAGE="http://manatee.sourceforge.net/jcvi/downloads.shtml"
SRC_URI="http://downloads.sourceforge.net/project/manatee/manatee/manatee-2.4.3/manatee-2.4.3.tgz"

LICENSE="Artistic-Manatee"
SLOT="0"
KEYWORDS=""
#KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/expat-1.95.8
		>=media-libs/gd-2.0.34
		dev-perl/DBI
		dev-perl/DBD-mysql
		dev-perl/XML-Parser
		dev-perl/XML-Twig
		dev-perl/XML-Simple
		dev-perl/XML-Writer
		dev-perl/HTML-Template
		dev-perl/Tree-DAG_Node
		perl-core/File-Spec
		perl-core/Data-Dumper
		dev-perl/GD
		perl-core/Storable
		dev-perl/Log-Log4perl
		dev-perl/Log-Cabin
		dev-perl/IO-Tee
		dev-perl/MLDBM"
		#dev-perl/CGI
		#dev-perl/CGI-Carp
		#dev-perl/CGI-Cookie
		#dev-perl/GD-Text
		#dev-perl/GD-Graph
		#dev-perl/Date-Manip
RDEPEND="${DEPEND}
		>=dev-db/mysql-5.0
		>=www-servers/apache-2.2"

S="${WORKDIR}"/manatee-"${PV}"

src_configure(){
	econf HTTPD=/usr/sbin/httpd HTTPD_SCRIPT_HOME=/var/www/cgi-bin HTTPD_DOC_HOME=/var/www/htdocs MYSQLD=/usr/sbin/mysqld
}

src_compile(){
	emake
}
