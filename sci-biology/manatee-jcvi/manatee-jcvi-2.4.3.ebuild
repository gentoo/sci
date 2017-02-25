# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Genome annotation tool"
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
		virtual/perl-File-Spec
		virtual/perl-Data-Dumper
		dev-perl/GD
		virtual/perl-Storable
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
		>=virtual/mysql-5:*
		>=www-servers/apache-2.2"

S="${WORKDIR}"/manatee-"${PV}"

src_configure(){
	econf HTTPD=/usr/sbin/httpd HTTPD_SCRIPT_HOME=/var/www/cgi-bin HTTPD_DOC_HOME=/var/www/htdocs MYSQLD=/usr/sbin/mysqld
}

src_compile(){
	default
}
