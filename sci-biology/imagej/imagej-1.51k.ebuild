# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2 eutils versionator

MY_PN="ij"
MY_PV=$(delete_all_version_separators)

# NOTE:
# as plugins are regularly lagging behind, we use the pack released for previous
# version instead. Change to present version locally if you are sure proper
# version has been released.
# see https://bugs.gentoo.org/show_bug.cgi?id=112275
# https://github.com/imagej/imagej1/issues/28
IJ_PV=$(expr ${MY_PV::3} - 1)

DESCRIPTION="Image Processing and Analysis in Java"
HOMEPAGE="http://rsb.info.nih.gov/ij/"

SRC_URI="http://imagej.nih.gov/ij/download/src/${MY_PN}${MY_PV}-src.zip
	http://rsb.info.nih.gov/ij/images/ImageJ.png
	plugins? ( http://wsr.imagej.net/distros/cross-platform/${MY_PN}${IJ_PV}.zip )"
# plugins are under a different licenses and can be installed into user's $IJ_HOME/plugins
#	plugins? ( http://rsb.info.nih.gov/ij/download/zips/${MY_PN}${IJ_PV}.zip )"

RESTRICT=""
LICENSE="public-domain" # http://imagej.net/disclaimer.html
SLOT="0"

KEYWORDS=""

IUSE="doc plugins debug"

RDEPEND=">=virtual/jre-1.6:*
	dev-java/java-config
	dev-java/jython"
DEPEND=">=virtual/jdk-1.6:*
	dev-java/ant-core
	${RDEPEND}"

S=${WORKDIR}/source
IJ_S=${WORKDIR}/ImageJ

src_prepare() {
	cp "${DISTDIR}"/ImageJ.png "${WORKDIR}/${PN}.png" || die

	if ! use debug ; then
		sed -i 's: debug="on">: debug="off">:' "${S}"/build.xml || die
	fi
	epatch "${FILESDIR}"/AutoThresholder.java.patch
	eapply_user
}

# in src_compile we get: !!! ERROR: Package jython was not found!
# TODO: overwrite calls to jython ? See
#   ij/plugin/frame/Editor.java
#   plugin/PlugInInterpreter.java
#   plugin/Macro_Runner.java

src_compile() {
	local antflags="build"
	use doc && antflags="${antflags} javadocs"

	ant ${antflags} || die  "ant build failed"

	# Max memory usage depends on available memory and CPU type
	MEM=$(grep MemTotal /proc/meminfo | cut -d':' -f2 | grep -o [0-9]*)
	IJ_MAX_MEM=$(expr ${MEM} / 1024)
	if use x86 && $IJ_MAX_MEM -gt 2048 ; then
		IJ_MAX_MEM=2048
	fi
	# build finished, generate startup wrapper
	cat <<EOF > "${T}/${PN}"
#!${EPREFIX}/bin/bash
IJ_LIB=${EPREFIX}/usr/share/${PN}/lib
if !([ "\${IJ_HOME}" ]) ; then
	IJ_HOME=\${HOME}/.imagej
fi
if [ -d \${IJ_HOME}/plugins ] ; then
	IJ_PLG=\${IJ_HOME}
else
	IJ_PLG=${EPREFIX}/usr/share/${PN}/lib
fi
if !([ "\$IJ_MEM" ]) ; then
	IJ_MEM=${IJ_MAX_MEM}
fi
if !([ "\$IJ_CP" ]) ; then
	IJ_CP=\$(java-config -p imagej):\$(java-config -O)/lib/tools.jar
else
	IJ_CP=\$(java-config -p imagej):\$(java-config -O)/lib/tools.jar:\${IJ_CP}
fi
\$(java-config --java) \\
	-Xmx\${IJ_MEM}m -Dswing.aatext=true \\
	-Dawt.useSystemAAFontSettings=on\\
	-cp \${IJ_CP} \\
	-Duser.home=\${IJ_HOME} \\
	-Dplugins.dir=\${IJ_PLG} \\
	ij.ImageJ "\$@"
EOF
}

src_install() {
	java-pkg_dojar *.jar
	dobin "${T}/${PN}"

	if use plugins ; then
		cp -R "${IJ_S}"/plugins "${ED}"/usr/share/"${PN}"/lib/
		cp -R "${IJ_S}"/macros "${ED}"/usr/share/"${PN}"/lib/
	fi

	use doc && java-pkg_dohtml -r "${WORKDIR}"/api

	insinto /usr/share/pixmaps
	doins "${WORKDIR}/${PN}".png
	make_desktop_entry "${PN}" ImageJ "${PN}".png Graphics
}

pkg_postinst() {
	einfo ""
	einfo "You can configure the path of a folder, which contains \"plugins\" directory and IJ_Prefs.txt,"
	einfo "by setting the environmental variable, \$IJ_HOME."
	einfo "Default setting is \$IJ_HOME=\${HOME}/.imagej, i.e. \${HOME}/.imagej/plugins and \${HOME}/.imagej/IJ_Prefs.txt."
	einfo ""
	einfo "You can also configure the memory size by setting the environmental variable, \$IJ_MEM,"
	einfo "and the class path by setting the environmental variable, \$IJ_CP."
	einfo ""
	einfo "If you want to use much more plugins, please see http://rsb.info.nih.gov/ij/plugins/index.html"
	einfo "and add *.class files to \$IJ_HOME/plugins folder"
	einfo ""
}
