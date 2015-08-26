# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils perl-module webapp

MY_P="GBrowse-${PV}"

DESCRIPTION="Display of genomic annotations on interactive web pages"
HOMEPAGE="http://gmod.org/"
# mirror://sourceforge/gmod/${MY_P}.tar.gz
# mirror://cpan/authors/id/L/LD/LDS/GBrowse-2.33.tar.gz
SRC_URI="
	mirror://cpan/authors/id/L/LD/LDS/${MY_P}.tar.gz
	test? (
		http://sourceforge.net/projects/gmod/files/Generic%20Genome%20Browser/Sample%20Data%20Files/saccharomyces_cerevisiae.gff.bz2
		http://sourceforge.net/projects/gmod/files/Generic%20Genome%20Browser/Sample%20Data%20Files/Refseq_Genome_TBLASTX.tar.gz
		http://sourceforge.net/projects/gmod/files/Generic%20Genome%20Browser/Sample%20Data%20Files/README-gff-files
		http://sourceforge.net/projects/gmod/files/Generic%20Genome%20Browser/Sample%20Data%20Files/human.gff.tar.gz
		http://sourceforge.net/projects/gmod/files/Generic%20Genome%20Browser/Sample%20Data%20Files/yeast.fasta.gz
		http://sourceforge.net/projects/gmod/files/Generic%20Genome%20Browser/Sample%20Data%20Files/yeast.gff.gz
		http://sourceforge.net/projects/gmod/files/Generic%20Genome%20Browser/Sample%20Data%20Files/worm.fasta.gz
		http://sourceforge.net/projects/gmod/files/Generic%20Genome%20Browser/Sample%20Data%20Files/worm.gff.gz
		http://sourceforge.net/projects/gmod/files/Generic%20Genome%20Browser/Sample%20Data%20Files/fly.fasta.gz
		http://sourceforge.net/projects/gmod/files/Generic%20Genome%20Browser/Sample%20Data%20Files/fly.gff.gz )"

LICENSE="Artistic"
# webapp ebuilds do not set SLOT
KEYWORDS="~x86 ~amd64"
IUSE="cgi fastcgi minimal mysql pdf postgres svg test" # lwp moby scf

S="${WORKDIR}/${MY_P}"

# TODO: dev-perl/MOBY, dev-perl/Bio-SCF, dev-perl/Safe-World (not compatible w/perl-5.10)
# how about mod_fcgi and dev-libs/fcgi and mod_scgi?
DEPEND="
	>=virtual/perl-Module-Build-0.380.0
	>=dev-lang/perl-5.8.8:=
	dev-perl/Capture-Tiny
	>=sci-biology/bioperl-1.6.901
	>=dev-perl/GD-2.07
	dev-perl/IO-String
	virtual/perl-Digest-MD5
	>=dev-perl/CGI-Session-4.03
	dev-perl/Statistics-Descriptive
	>=dev-perl/Bio-Graphics-1.97
	>=dev-perl/JSON-2.510.0
	dev-perl/TermReadKey
	dev-perl/libwww-perl
	svg? ( dev-perl/GD-SVG )
	pdf? ( media-gfx/inkscape )
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	sci-biology/ucsc-genome-browser" # that provides bigWig.h and jkweb.a, aka Jim Kent's src

# TODO: based on the following message in apache/error_log the list of deps should be longer
# GBROWSE NOTICE: To enable PDF generation, please enter the directory "/home/httpd" and run the commands: "sudo mkdir .inkscape .gnome2" and "sudo chown apache .inkscape .gnome2".  To turn off this message add "generate pdf = 0" to the [GENERAL] section of your GBrowse.conf configuration file., referer: http://127.0.0.1/gbrowse/cgi-bin/gbrowse_details/yeast?ref=chrII;start=90739;end=92028;name=YBL069W;class=Sequence;feature_id=881;db_id=annotations%3Adatabase

RDEPEND="${DEPEND}
	>=www-servers/apache-2.0.47
	fastcgi? ( dev-libs/fcgi )
	www-apache/mod_fastcgi
	dev-perl/DBI
	|| ( dev-perl/DBD-Pg dev-perl/DBD-mysql )
	!minimal? (
		dev-perl/File-NFSLock
		dev-perl/FCGI
		virtual/perl-Math-BigInt
		virtual/perl-Math-BigInt-FastCalc
		dev-perl/Math-BigInt-GMP
		dev-perl/Digest-SHA1
		dev-perl/Crypt-SSLeay
		dev-perl/Net-SMTP-SSL
		dev-perl/Net-OpenID-Consumer
		virtual/perl-DB_File
		dev-perl/DB_File-Lock
		dev-perl/GD-SVG
		dev-perl/Text-Shellwords
		dev-perl/XML-Twig
		dev-perl/XML-DOM
		dev-perl/XML-Writer
		dev-perl/XML-Parser
		dev-perl/Bio-Das
		dev-perl/Text-Shellwords
		postgres? ( >=dev-perl/Bio-DB-Das-Chado-0.32 )
		>=dev-perl/Bio-SamTools-1.29
		>=dev-perl/Bio-BigFile-1.06
	)"

src_prepare() {
	sed -i 's/return unless -t STDIN/return/' install_util/GBrowseInstall.pm || die
	sed -i 's/process_/bp_process_/g' INSTALL || die
	epatch \
		"${FILESDIR}"/GBrowseInstall.pm-"${PV}".patch \
		"${FILESDIR}"/destdir.patch \
		"${FILESDIR}"/fix-PNG-export.patch \
		"${FILESDIR}"/symlink.patch \
		"${FILESDIR}"/gbrowse_metadb_config.pl.patch \
		"${FILESDIR}"/disable-gbrowse_metadb_config.pl.patch
}

src_configure() {
	# GBROWSE_ROOT is the root path in SRC_URI to be prepended
	# /usr/share/webapps/gbrowse/2.03/htdocs/etc/gbrowse/GBrowse.conf
	webapp_src_preinst
	perl Makefile.PL \
		HTDOCS="${MY_HTDOCSDIR}" \
		CGIBIN="${MY_HTDOCSDIR}"/cgi-bin \
		CONF="${MY_HTDOCSDIR}"/etc/gbrowse \
		PACKAGE_DIR="${D}" \
		INSTALLDIRS=vendor \
		GBROWSE_ROOT="gbrowse" \
		DESTDIR="${D}" \
		DATABASES="/var/www/gbrowse2/databases/" \
		TMP="/var/tmp/gbrowse2" \
		INSTALLETC="n" \
		INSTALLCONF="n" \
		WWWUSER="apache" \
		DO_XS=1 \
		NONROOT=1 \
		|| die
}

src_install() {
	mydoc="Changes README TODO INSTALL"
	perl-module_src_install

	# TODO: write our own readme
	webapp_postinst_txt en "${S}"/INSTALL
	webapp_src_install || die "Failed running webapp_src_install"

	# should create a /etc/init.d/ startup script based on this
	# /var/tmp/portage/sci-biology/gbrowse-2.03/work/GBrowse-2.03/etc/init.d/gbrowse-slave

	chown -R apache.apache "${D}"/var/www/gbrowse2/databases || die

	mkdir -p "${D}"/var/www/localhost/htdocs/gbrowse || die
	ln -s "${D}"/var/tmp/gbrowse2/images "${D}"/var/www/localhost/htdocs/gbrowse/i || die

	einfo "Probably you want to install a cron job to remove the generated temporary images:"
	einfo "find /var/tmp/gbrowse2/images -type f -atime +20 -print -exec rm {}"

	einfo "Make sure you compiled apache with +cgi and copy ${FILESDIR}/gbrowse.conf.vhosts.d to /etc/apache2/vhosts.d/"

	sed -i "s#"${D}"##g" "${S}"/install_util/GBrowseInstall.pm || die
	sed -i "s#"${D}"##" "${S}"/blib/conf/GBrowse.conf* || die
	sed -i 's#DBI:SQLite:'${D}'/var/www/gbrowse2/databases/#DBI:SQLite:/var/www/gbrowse2/databases/#' "${S}"/install_util/GBrowseInstall.pm || die
}

pkg_postinst() {
	webapp_pkg_postinst || die "webapp_pkg_postinst failed"

	einfo "Please run gbrowse_metadb_config.pl to update SQLite flatfiles of the live database."
}

src_test() {
	mysql -uroot -p password -e 'create database yeast'
	mysql -uroot -p password -e 'grant all privileges on yeast.* to gbrowse@localhost'
	mysql -uroot -p password -e 'grant file on *.* to gbrowse@localhost'
	mysql -uroot -p password -e 'grant select on yeast.* to nobody@localhost'

	cd /usr/portage/distfiles || die
	gzip -d yeast.fasta.gz || die
	gzip -d yeast.gff.gz || die
	#gzip -d fly.fasta.gz
	#gzip -d fly.gff.gz
	bp_bulk_load_gff.pl -d yeast -fasta yeast.fasta yeast.gff || die
}
