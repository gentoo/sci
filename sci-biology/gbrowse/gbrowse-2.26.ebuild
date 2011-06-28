# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="2"

inherit perl-module webapp

MY_P="GBrowse-${PV}"

DESCRIPTION="Display of genomic annotations on interactive web pages"
HOMEPAGE="http://gmod.org/"
SRC_URI="
	mirror://sourceforge/gmod/${MY_P}.tar.gz
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
IUSE="-minimal svg test" # lwp moby scf

S="${WORKDIR}/${MY_P}"

# TODO: dev-perl/MOBY, dev-perl/Bio-SCF, dev-perl/Safe-World (not compatible w/perl-5.10)
# TODO: make sure www-servers/apache +cgi
DEPEND="
	>=dev-lang/perl-5.8.8
	dev-perl/Capture-Tiny
	>=sci-biology/bioperl-1.6
	>=dev-perl/GD-2.07
	dev-perl/IO-String
	virtual/perl-Digest-MD5
	>=dev-perl/CGI-Session-4.03
	dev-perl/Statistics-Descriptive
	>=dev-perl/Bio-Graphics-1.97
	dev-perl/JSON
	dev-perl/libwww-perl
	svg? ( dev-perl/GD-SVG )"

# TODO: based on the following message in apache/error_log the list of deps should be longer
# GBROWSE NOTICE: To enable PDF generation, please enter the directory "/home/httpd" and run the commands: "sudo mkdir .inkscape .gnome2" and "sudo chown apache .inkscape .gnome2".  To turn off this message add "generate pdf = 0" to the [GENERAL] section of your GBrowse.conf configuration file., referer: http://127.0.0.1/gbrowse/cgi-bin/gbrowse_details/yeast?ref=chrII;start=90739;end=92028;name=YBL069W;class=Sequence;feature_id=881;db_id=annotations%3Adatabase

#    *  Bio::DB::BigFile is not installed
#    *  Bio::DB::Sam is not installed
#    *  DBD::Pg is not installed

RDEPEND="${DEPEND}
	>=www-servers/apache-2.0.47
	www-apache/mod_fastcgi
	dev-perl/DBI
	|| ( dev-perl/DBD-Pg dev-perl/DBD-mysql )
	!minimal? (
		dev-perl/File-NFSLock
		dev-perl/FCGI
		perl-core/Math-BigInt
		perl-core/Math-BigInt-FastCalc
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
	)"

src_prepare() {
	sed -i 's/return unless -t STDIN/return/' install_util/GBrowseInstall.pm || die
	sed -i 's/process_/bp_process_/g' INSTALL || die
	epatch "${FILESDIR}"/GBrowseInstall.pm-"${PV}".patch || die "Failed to patch"
	epatch "${FILESDIR}"/GBrowseInstall.pm-disable-gbrowse_metadb_config.pl"${PV}".pm.patch || die "Failed to patch"
}

src_configure() {
	# GBROWSE_ROOT is the root path in SRC_URI to be prepended
	# /usr/share/webapps/gbrowse/2.03/htdocs/etc/gbrowse/GBrowse.conf

	# if we use CONF="${D}${MY_HTDOCSDIR}"/etc/gbrowse the the install process
	# will not find currently installed config files and therefore place *.conf
	# files into "{$S}"/blib/conf/*.conf instead of creating "{$S}"/blib/conf/*.conf.new
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

	#sed -i 's#DBI:SQLite:#DBI:SQLite:'${D}'#' "${S}"/install_util/GBrowseInstall.pm || die
	#sed -i 's#DBI:SQLite:#DBI:SQLite:'${D}'#' "${S}"/conf/GBrowse.conf || die
	#sed -i 's#/var/www/gbrowse2/databases/#'${D}'/var/www/gbrowse2/databases/#' "${S}"/_build/build_params
	#sed -i 's#/var/www/gbrowse2/databases/#'${D}'/var/www/gbrowse2/databases/#' "${S}"/_build/config_data
	#sed -i 's#/var/www/gbrowse2/databases/#'${D}'/var/www/gbrowse2/databases/#' "${S}"/_build/runtime_params
}

src_install() {
	mydoc="Changes README TODO INSTALL"
	perl-module_src_install

	# TODO: write our own readme
	webapp_src_preinst
	webapp_postinst_txt en "${S}"/INSTALL || die
	webapp_src_install

	# should create a /etc/init.d/ startup script based on this
	# /var/tmp/portage/sci-biology/gbrowse-2.03/work/GBrowse-2.03/etc/init.d/gbrowse-slave

	# pre-create the directory so we can force its owner later on
	mkdir -p "${D}"/var/www/gbrowse2/databases || die
	chown -R apache.apache "${D}"/var/www/gbrowse2/databases || die
	mkdir -p "${D}"/var/www/localhost/htdocs/gbrowse || die

	ln -s "${D}"/var/tmp/gbrowse2/images "${D}"/var/www/localhost/htdocs/gbrowse/i || die

	einfo "Probably you want to install a cron job to remove the generated temporary images:"
	einfo "find /var/tmp/gbrowse2/images -type f -atime +20 -print -exec rm {}"

	einfo "Make sure you compiled apache with +cgi and copy ${FILESDIR}/gbrowse.conf.vhosts.d to /etc/apache2/vhosts.d/"

	sed -i "s#"${D}"##g" "${S}"/install_util/GBrowseInstall.pm || die
	sed -i "s#"${D}"##" "${S}"/blib/conf/GBrowse.conf*
	sed -i 's#DBI:SQLite:'${D}'/var/www/gbrowse2/databases/#DBI:SQLite:/var/www/gbrowse2/databases/#' "${S}"/install_util/GBrowseInstall.pm || die
}

pkg_postinst() {
	webapp_pkg_postinst || die "webapp_pkg_postinst failed"

	einfo "Please run gbrowse_metadb_config.pl to upate SQlite flatfiles or the live database"
	einfo "This was disabled by "${FILESDIR}"/GBrowseInstall.pm-disable-gbrowse_metadb_config.pl.pm.patch"
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
