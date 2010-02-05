# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/generic-genome-browser/generic-genome-browser-1.58.ebuild,v 1.9 2007/07/29 17:07:38 phreak Exp $

EAPI="2"

inherit perl-module webapp

MY_P="GBrowse-${PV}"

DESCRIPTION="The generic genome browser provides a display of genomic annotations on interactive web pages"
HOMEPAGE="http://gmod.org"
SRC_URI="mirror://sourceforge/gmod/${MY_P}.tar.gz"

LICENSE="Artistic"
# webapp ebuilds do not set SLOT
KEYWORDS="~x86 ~amd64"
IUSE="-minimal" # lwp moby scf

S="${WORKDIR}/${MY_P}"

# TODO: dev-perl/MOBY, dev-perl/Bio-SCF, dev-perl/Safe-World (not compatible w/perl-5.10)
DEPEND=">=dev-lang/perl-5.8.8
	>=sci-biology/bioperl-1.6
	>=dev-perl/GD-2.07
	dev-perl/IO-String
	virtual/perl-Digest-MD5
	>=dev-perl/CGI-Session-4.03
	dev-perl/Statistics-Descriptive
	>=dev-perl/Bio-Graphics-1.97
	dev-perl/JSON
	dev-perl/libwww-perl"
RDEPEND="${DEPEND}
	>=www-servers/apache-2.0.47
	dev-perl/DBI
	|| ( dev-perl/DBD-Pg dev-perl/DBD-mysql )
	!minimal? (
		dev-perl/File-NFSLock
		dev-perl/FCGI
		perl-core/Math-BigInt
		dev-perl/Digest-SHA1
		dev-perl/Crypt-SSLeay
		dev-perl/Net-SMTP-SSL
		dev-perl/GD-SVG
		dev-perl/Net-OpenID-Consumer
		virtual/perl-DB_File
		dev-perl/DB_File-Lock
	)"

src_prepare() {
	sed -i 's/return unless -t STDIN/return/' install_util/GBrowseInstall.pm || die
}

src_configure() {
	webapp_src_preinst
	perl Makefile.PL \
		HTDOCS="${D}/${MY_HTDOCSDIR}" \
		CGIBIN="${D}/${MY_HTDOCSDIR}/cgi-bin" \
		CONF="${D}/etc" \
		PREFIX="${D}/usr" \
		PACKAGE_DIR="${D}" \
		INSTALLDIRS=vendor \
		GBROWSE_ROOT=gbrowse \
		DESTDIR="${ROOT}" \
		|| die
}

src_install() {
	mydoc="Changes README TODO INSTALL"
	perl-module_src_install

	# TODO: write our own readme
	webapp_postinst_txt en "${S}/INSTALL"
	webapp_src_install
#	find "${D}" -type f | xargs sed -i "s|${D}||" || die
}
