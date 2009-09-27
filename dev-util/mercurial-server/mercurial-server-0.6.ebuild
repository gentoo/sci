# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Mercurial authentication and authorization tools"
HOMEPAGE="http://hg.opensource.lshift.net/mercurial-server/"
SRC_URI="http://hg.opensource.lshift.net/mercurial-server/archive/release_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-util/mercurial"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-release_${PV}"

pkg_setup() {
	enewgroup hg
	enewuser hg -1 /bin/sh /home/hg hg
	chmod 700 /home/hg
}

src_install () {
	#no distutils support yet
	./install --root="${D}" --prefix=/usr || die "install failed"

	#Move doc
	cd "${D}"/usr/share/doc
	dodoc -r "${PN}"/*
	rm -rf "${PN}"

	#purge is an extension now
	echo -e "\n[extensions]\npurge =\n" >> "${D}"/etc/mercurial-server/remote-hgrc

	#NOTE to prefix guys you may have to:
	#-change getEtcPath function in paths.py
	#-disable creation of user hg
}

pkg_postinst() {
	#skip the comments if there is already a hgadmin repo
	[ -d /home/hg/repos/hgadmin/.hg ] && return

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
}
