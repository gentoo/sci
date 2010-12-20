# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"

inherit eutils python

DESCRIPTION="Mercurial authentication and authorization tools"
HOMEPAGE="http://www.lshift.net/mercurial-server.html"
SRC_URI="http://dev.lshift.net/paul/mercurial-server/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-vcs/mercurial"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt"

S="${WORKDIR}/${PN}_${PV}"
HG_HOME="/var/lib/hg"

pkg_setup() {
	enewgroup hg
	enewuser hg -1 /bin/sh "${HG_HOME}" hg
	keepdir "${HG_HOME}"
	fowners hg:hg "${HG_HOME}"
	fperms 700 "${HG_HOME}"
	python_set_active_version 2
}

src_compile() {
	emake DOCBOOK_XSL="${EPREFIX}"/usr/share/sgml/docbook/xsl-stylesheets || die "emake failed"
}

src_install() {
	emake installfiles PREFIX="${EPREFIX}"/usr/share \
		DOCDIR="${EPREFIX}/usr/share/doc/${PF}" \
		DESTDIR="${D}" || die "emake installfiles failed"
}

pkg_postinst() {
	#skip the comments if there is already a hgadmin repo
	if [ ! -d "${EPREFIX}"/home/hg/repos/hgadmin/.hg ] && \
		[ ! -d "${EPREFIX}${HG_HOME}"/repos/hgadmin/.hg ]; then
		#Parts could be done automatically, but maybe there is a user hg
		elog "This seem to be a first time install, things you may want to do"
		elog "-Add your public ssh key to root key folder"
		elog "  su -c \"cp ~/.ssh/id_rsa.pub ${EROOT}etc/mercurial-server/keys/root/\${USER}\""
		elog "-Create hgadmin repo"
		elog "  su - hg -c \"${EROOT}usr/share/mercurial-server/init/hginit ${EROOT}usr/share/mercurial-server\""
		elog "-Init hg's ssh authorized_keys file"
		elog "  su - hg -c \"${EROOT}usr/share/mercurial-server/refresh-auth\""
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
		elog "-Remove the key in ${EROOT}etc/mercurial-server/keys/root"
		elog "  rm ${EROOT}etc/mercurial-server/keys/root/\${USER}"
	fi
	ewarn "If you are upgrading from an older version of ${PN}, please take a look at"
	ewarn "${EROOT}usr/share/mercurial-server/init/dot-mercurial-server"
	ewarn "and add missing lines to ~hg/.mercurial-server"
	ewarn ""
	ewarn "With ${PN}>=1.1 the default location of the repositories has been"
	ewarn "moved from ${EROOT}hg/home to ${EROOT}${HG_HOME#/} !"
	ewarn "home directory can be moved with 'usermod -m -d ${HG_HOME}' hg"
}
