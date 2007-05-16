# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# This ebuild is still VERY rough...

inherit eutils java-pkg-2 webapp

DESCRIPTION="Jmol is a java molecular viever for 3-D chemical structures."
SRC_URI="mirror://sourceforge/${PN}/${P}-full.tar.gz"
HOMEPAGE="http://jmol.sourceforge.net/"
KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1"

IUSE="vhosts"

RDEPEND=">=virtual/jre-1.4" 
DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core
	dev-java/ant-contrib
	dev-java/commons-cli
	dev-java/itext
	dev-java/junit
	dev-java/gnu-jaxp
	dev-java/sax
	dev-java/saxon
	sci-chemistry/jmol-acme
	vhosts? ( app-admin/webapp-config )"

pkg_setup() {

	if use vhosts ; then
		webapp_pkg_setup || die "Failed to setup webapp"
	fi

}

src_unpack() {

	unpack ${A}
	epatch "${FILESDIR}"/${P}-nointl.patch
	epatch "${FILESDIR}"/${P}-manifest.patch

pwd &&	sed -i "s:${PN}:${P}\/lib:" "${S}/${PN}" || die "Failed running sed."
	mkdir "${S}"/selfSignedCertificate || die "Failed to create Cert directory."
	cp "${FILESDIR}"/selfSignedCertificate.store "${S}"/selfSignedCertificate/ \
		|| die "Failed to install Cert file."

	cd "${S}/jars"

	java-pkg_jar-from --build-only ant-contrib
	java-pkg_jar-from --build-only itext
	java-pkg_jar-from --build-only junit
	java-pkg_jar-from --build-only gnu-jaxp
#	java-pkg_jar-from sax
	java-pkg_jar-from --build-only saxon
	java-pkg_jar-from --build-only commons-cli-1 commons-cli.jar commons-cli-1.0.jar
	java-pkg_jar-from --build-only jmol-acme jmol-acme.jar Acme.jar
#	java-pkg_jar-from --build-only sun-java3d-bin vecmath.jar

}

src_compile() {

	ant || die "Compilation problem"

}


src_install() {

	java-pkg_dojar   Jmol.jar JmolApplet.*  
	dohtml -r  build/doc/* || die "Failed to install html docs."
	dodoc *.txt doc/*license* || die "Failed to install licenses."
	edos2unix jmol || die "Failed to convert jmol from DOS format."
	dobin jmol || die "Failed to install startup script."

	if use vhosts ; then
		webapp_src_preinst || die "Failed webapp_src_preinst."
		cmd="cp Jmol.* "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed." 
		cmd="cp jmol "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp JmolApplet.* "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp applet.classes "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp -r build/classes/* "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp -r build/appjars/* "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp "${FILESDIR}"/caffeine.xyz "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp "${FILESDIR}"/index.html "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."

		webapp_src_install || die "Failed running webapp_src_install"
	fi
	
}

pkg_postinst() {
	
	if use vhosts ; then
		webapp_pkg_postinst || die "webapp_pkg_postinst failed"
	fi

}

pkg_prerm() {

	if use vhosts ; then
		webapp_pkg_prerm || die "webapp_pkg_prerm failed"
	fi

}

