# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 webapp

DESCRIPTION="Jmol is a java molecular viever for 3-D chemical structures."
SRC_URI="mirror://sourceforge.net/${PN}/${P}-full.tar.gz"
HOMEPAGE="http://jmol.sourceforge.net/"
KEYWORDS="~amd64"
LICENSE="LGPL-2.1"

IUSE=""
SLOT="0"

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jre-1.4
	dev-java/ant-core
	vhosts? ( app-admin/webapp-config )"


pkg_setup() {
	
	if use vhosts ; then
		webapp_pkg_setup || die "Failed to setup webapp"
	fi

}

src_unpack() {

	unpack ${A}
	cd "${S}"

# i18n is broken without files from svn.
	epatch "${FILESDIR}"/${P}-nointl.patch || die "Failed nointl patch."

	epatch "${FILESDIR}"/${P}-manifest.patch || die "Failed manifest patch."

	sed -i "s/${PN}/${P}\/lib/" "${PN}" || die "Failed running sed."

	mkdir "${S}"/selfSignedCertificate || die "Failed to create Cert directory."
	
	cp "${FILESDIR}"/selfSignedCertificate.store "${S}"/selfSignedCertificate/ \
		|| die "Failed to install Cert file."

}

src_compile() {

	ant || die "Compilation problem"

}


src_install() {

	java-pkg_dojar   Jmol.jar JmolApplet.* || die "Failed to install jars."
	dohtml -r  build/doc/* || die "Failed to install html docs."
	dodoc  *.txt doc/*license* || die "Failed to install licenses."
	edos2unix jmol || die "Failed to convert jmol from DOS format."
	dobin   jmol || die "Failed to install startup script."

	if use vhosts ; then
		webapp_src_preinst || die "Failed webapp_src_preinst."
		cp Jmol.* "${D}${MY_HTDOCSDIR}" || die 
		cp jmol "${D}${MY_HTDOCSDIR}" || die
		cp JmolApplet.* "${D}${MY_HTDOCSDIR}" die
		cp applet.classes "${D}${MY_HTDOCSDIR}" || die
		cp -r build/classes/* "${D}${MY_HTDOCSDIR}" || die 
		cp -r build/appjars/* "${D}${MY_HTDOCSDIR}" || die 
		cp "${FILESDIR}"/caffeine.xyz "${D}${MY_HTDOCSDIR}" || die
		cp "${FILESDIR}"/index.html "${D}${MY_HTDOCSDIR}" || die

		webapp_src_install || die "Failed running webapp_src_install"
	fi
	
}

pkg_postinst() {
	
	if use vhosts ; then
		webapp_pkg_postinst || die "pkg_postinst failed"
	fi

}

pkg_prerm() {

	if use vhosts ; then
		webapp_pkg_prerm || die "pkg_prerm failed"
	fi

}

