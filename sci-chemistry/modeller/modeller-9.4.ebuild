# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python

MY_PV="${PV/./v}"
LICENSE="modeller"
KEYWORDS="~amd64 ~x86"
DESCRIPTION="MODELLER is used for homology or comparative modeling of protein three-dimensional structures"
SRC_URI="http://salilab.org/${PN}/${MY_PV}/${PN}-${MY_PV}.tar.gz"
HOMEPAGE="http://salilab.org/${PN}/"
IUSE=""
RESTRICT="mirror"
SLOT="0"

RDEPEND=">=dev-lang/python-2.4"
DEPEND=""

src_install(){
	python_version

	VER=9v4
	case ${ARCH} in
		x86)	EXECUTABLE_TYPE="i386-intel8";;
		amd64)	EXECUTABLE_TYPE="x86_64-intel8";;
		*)		ewarn "Your arch "${ARCH}" does not appear supported at this time."||\
				die "Unsupported Arch";;
	esac

	IN_PATH=/opt/modeller${VER}

	sed -e "s:EXECUTABLE_TYPE${VER}=xxx:EXECUTABLE_TYPE${VER}=${EXECUTABLE_TYPE}:g" \
	-e "s:MODINSTALL${VER}=xxx:MODINSTALL${VER}=\"${IN_PATH}\":g" \
	modeller-${VER}/bin/modscript > "${T}/mod${VER}"
	exeinto ${IN_PATH}/bin/
	doexe "${T}/mod${VER}"
	dosym ${IN_PATH}/bin/mod${VER} /opt/bin/mod${VER}

	sed -e "s;@TOPDIR\@;\"${IN_PATH}\";" \
	-e "s;@EXETYPE\@;$EXECUTABLE_TYPE;" \
	modeller-${VER}/bin/modpy.sh.in > "${T}/modpy.sh"
	doexe "${T}/modpy.sh"

	insinto ${IN_PATH}/bin/
	doins -r modeller-${VER}/bin/{*top,lib}
	exeinto ${IN_PATH}/bin/
	doexe modeller-${VER}/bin/{modslave.py,mod${VER}_${EXECUTABLE_TYPE}}

	exeinto /usr/lib/python${PYVER}/site-packages/
	doexe modeller-${VER}/lib/${EXECUTABLE_TYPE}/_modeller.so
	dosym ${IN_PATH}/modlib/modeller /usr/lib/python${PYVER}/site-packages/modeller
	dosym ${IN_PATH}/lib/${EXECUTABLE_TYPE}/_modeller.so\
		  /usr/lib/python${PYVER}/site-packages/_modeller.so

	exeinto ${IN_PATH}/lib/${EXECUTABLE_TYPE}/
	doexe modeller-${VER}/lib/${EXECUTABLE_TYPE}/{lib*,_modeller.so}
	exeinto ${IN_PATH}/lib/${EXECUTABLE_TYPE}/python${PYVER}/
	doexe modeller-${VER}/lib/${EXECUTABLE_TYPE}/python2.5/_modeller.so
	dosym ${IN_PATH}/lib/${EXECUTABLE_TYPE}/libmodeller.so.1 \
		  ${IN_PATH}/lib/${EXECUTABLE_TYPE}/libmodeller.so

	insinto ${IN_PATH}/modlib/
	doins -r modeller-${VER}/modlib/{*mat,*lib,*prob,*mdt,*bin,*de,*inp,*ini,modeller}

	insinto ${IN_PATH}/
	doins -r modeller-${VER}/src

	insinto /usr/share/${PN}/
	doins -r modeller-${VER}/examples
	dohtml modeller-${VER}/doc/*
	dodoc modeller-${VER}/{README,ChangeLog}

	cat >> "${T}/config.py" <<- EOF
	install_dir = "${IN_PATH}/"
	license = "YOURLICENSEKEY"
	EOF

	insinto ${IN_PATH}/modlib/modeller/
	doins "${T}/config.py"
}

pkg_postinst(){
	#Adapted from BUG #127628
	einfo ""
	einfo " If you need to define your own residues"
	einfo " read the FAQ and edit the following files:"
	einfo ""
	einfo "    ${MY_D}/modlib/top_heav.lib"
	einfo "    ${MY_D}/modlib/radii.lib"
	einfo "    ${MY_D}/modlib/radii14.lib"
	einfo "    ${MY_D}/modlib/restyp.lib"
	einfo ""
	einfo "    Good Luck and Happy Modeling :D"
	einfo ""
	echo
	echo
	ewarn "Obtain a license Key from"
	ewarn "http://salilab.org/modeller/registration.html"
	ewarn "and change the appropriate line in"
	ewarn "${IN_PATH}/modlib/modeller/config.py"
}
