# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Mercurial authentication and authorization tools"
HOMEPAGE="http://www.lshift.net/mercurial-server.html"
SRC_URI="http://dev.lshift.net/paul/mercurial-server/mercurial-server_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-util/mercurial
	dev-lang/python
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt"

RDEPEND="dev-util/mercurial
	dev-lang/python"

S="${WORKDIR}/${PN}_${PV}.orig"

pkg_setup() {
	enewgroup hg
	enewuser hg -1 /bin/sh /home/hg hg
	chmod 700 /home/hg
}

src_compile() {
	emake DOCBOOK_XSL=/usr/share/sgml/docbook/xsl-stylesheets || die "emake failed"
}

src_install() {
	emake installfiles PREFIX=/usr/share DOCDIR="/usr/share/doc/${PF}" DESTDIR="${D}"
}


pkg_postinst() {
	#skip the comments if there is already a hgadmin repo
	if [ ! -d /home/hg/repos/hgadmin/.hg ]; then
		#Parts could be done automatically, but maybe there is a user hg 
		elog "This seem to be a first time install, things you may want to do"
		elog "-Add your public ssh key to root key folder"
		elog "  sudo cp ~/.ssh/id_rsa.pub ${ROOT}etc/mercurial-server/keys/root/\${USER}"
		elog "-Create hgadmin repo"
		elog "  sudo -u hg ${ROOT}usr/share/mercurial-server/init/hginit ${ROOT}usr/share/mercurial-server"
		elog "-Init hg's ssh authorized_keys file"
		elog "  sudo -u hg ${ROOT}usr/share/mercurial-server/refresh-auth"
		elog "-Clone hgadmin repo"
		elog "  hg clone ssh://hg@localhost/hgadmin hgadmin"
		elog "-Start administration"
		elog "  cd hgadmin"
		elog "  mkdir -p keys/root"
		elog "  cp ${ROOT}etc/mercurial-server/keys/root/\${USER} keys/root"
		elog "  cp ${ROOT}etc/mercurial-server/access.conf ."
		elog "  hg add"
		elog "  hg commit -m 'initial commit'"
		elog "  hg push ssh://hg@localhost/hgadmin"
		elog "-Remove the key in ${ROOT}etc/mercurial-server/keys/root"
		elog "  rm ${ROOT}etc/mercurial-server/keys/root/\${USER}"
	fi
	ewarn "If you are upgrading from an older version of ${PN}, please take a look at"
	ewarn "${ROOT}usr/share/mercurial-server/init/dot-mercurial-server"
	ewarn "and add missing lines to ~hg/.mercurial-server"
}
