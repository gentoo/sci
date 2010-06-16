# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python

MY_PV="${PV/./v}"
LICENSE="modeller"
KEYWORDS="~amd64 ~x86"
DESCRIPTION="MODELLER is used for homology or comparative modeling of protein three-dimensional structures"
SRC_URI="http://salilab.org/${PN}/${MY_PV}/${PN}-${MY_PV}.tar.gz"
HOMEPAGE="http://salilab.org/modeller/"
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

	sed -e "s:EXECUTABLE_TYPE${MY_PV}=xxx:EXECUTABLE_TYPE${MY_PV}=${EXECUTABLE_TYPE}:g" \
		-e "s:MODINSTALL${MY_PV}=xxx:MODINSTALL${MY_PV}=\"${IN_PATH}\":g" \
		bin/modscript > "${T}/mod${MY_PV}"
	exeinto ${IN_PATH}/bin/
	doexe "${T}/mod${MY_PV}"
	dosym ${IN_PATH}/bin/mod${MY_PV} /opt/bin/mod${MY_PV}

	sed -e "s;@TOPDIR\@;\"${IN_PATH}\";" \
		-e "s;@EXETYPE\@;$EXECUTABLE_TYPE;" \
		bin/modpy.sh.in > "${T}/modpy.sh"
	doexe "${T}/modpy.sh"

	insinto ${IN_PATH}
	doins -r modlib

	insinto ${IN_PATH}/bin
	doins -r bin/{lib,*top}
	exeinto ${IN_PATH}/bin
	doexe bin/{modslave.py,mod${MY_PV}_${EXECUTABLE_TYPE}}

	exeinto ${IN_PATH}/lib/${EXECUTABLE_TYPE}/
	doexe lib/${EXECUTABLE_TYPE}/lib*
	dosym libmodeller.so.3 ${IN_PATH}/lib/${EXECUTABLE_TYPE}/libmodeller.so
	doexe src/swig/build/lib.linux-$(uname -m)-${PYVER}/_modeller.so

	dodoc README INSTALLATION
	if use doc; then
		dohtml doc/*
	fi
	if use examples; then
		insinto /usr/share/${PN}/
		doins -r examples
	fi

	dosym ${IN_PATH}/lib/${EXECUTABLE_TYPE}/_modeller.so \
		  /usr/$(get_libdir)/python${PYVER}/site-packages/_modeller.so
}

pkg_postinst() {
	python_mod_optimize "${ROOT%/}/${IN_PATH}/"
	
	if [[ ! -e "${IN_PATH}/modlib/modeller/config.py" ]]; then
		echo install_dir = '"'"${IN_PATH}/"'"'> ${IN_PATH}/modlib/modeller/config.py
	fi

	if grep -q license ${IN_PATH}/modlib/modeller/config.py; then
		einfo "A license key file is already present in ${IN_PATH}/modlib/modeller/config.py"
	else
		ewarn "Obtain a license Key from"
		ewarn "http://salilab.org/modeller/registration.html"
		ewarn "And run this before using modeller:"
		ewarn "emerge --config =${CATEGORY}/${PF}"
		ewarn "That way you can [re]enter your license key."
	fi
}

pkg_postrm() {
	python_mod_cleanup "${ROOT%/}/${IN_PATH}/"
	ewarn "This package leaves a license Key file in ${IN_PATH}/modlib/modeller/config.py"
	ewarn "that you need to remove to completely get rid of modeller."
}

pkg_config() {
	ewarn "Your license key is NOT checked for validity here."
	ewarn "  Make sure you type it in correctly."
	eerror "If you CTRL+C out of this, modeller will not run!"
	while true
	do
		einfo "Please enter your license key:"
		read license_key1
		einfo "Please re-enter your license key:"
		read license_key2
		if [[ "$license_key1" == "" ]]
		then
			echo "You entered a blank license key.  Try again."
		else
			if [[ "$license_key1" == "$license_key2" ]]
			then
				echo license = '"'$license_key1'"' >> "${IN_PATH}/modlib/modeller/config.py"
				einfo "Thank you!"
				break
			else
				eerror "Your license key entries do not match.  Try again."
			fi
		fi
	done
}
