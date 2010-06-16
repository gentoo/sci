# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.6"

inherit distutils eutils versionator

MY_PV="$(replace_all_version_separators v)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Homology or comparative modeling of protein three-dimensional structures"
SRC_URI="http://salilab.org/${PN}/${MY_PV}/${PN}-${MY_PV}.tar.gz"
HOMEPAGE="http://salilab.org/modeller/"

LICENSE="modeller"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"
SLOT="0"

RESTRICT="mirror"

DEPEND=">=dev-lang/swig-1.3"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

INPATH="${EPREFIX}"/opt/modeller${ver}

QA_TEXTRELS="${INPATH#/}/*"
QA_EXECSTACK="${INPATH#/}/*"
QA_PRESTRIPPED="${INPATH#/}/bin/.* ${INPATH#/}/lib/*/.*"
QA_DT_HASH="
	${INPATH#/}/bin/.*
	${INPATH#/}/lib/*/.*"

pkg_setup() {
	python_set_active_version 2

	case ${ARCH} in
		x86)	EXECTYPE="i386-intel8";;
		amd64)	EXECTYPE="x86_64-intel8";;
		*)		ewarn "Your arch "${ARCH}" does not appear supported at this time."||\
				die "Unsupported Arch";;
	esac
}

src_prepare(){
	sed "s:i386-intel8:${EXECTYPE}:g" -i src/swig/setup.py || die
}

src_compile(){
	cd src/swig
	swig -python -keyword -nodefaultctor -nodefaultdtor -noproxy modeller.i
	distutils_src_compile
}

src_install(){
	sed \
		-e "s:EXECUTABLE_TYPE${MY_PV}=xxx:EXECUTABLE_TYPE${MY_PV}=${EXECTYPE}:g" \
		-e "s:MODINSTALL${MY_PV}=xxx:MODINSTALL${MY_PV}=\"${INPATH}\":g" \
		bin/modscript > "${T}/mod${MY_PV}"

	sed -e "s;@TOPDIR\@;\"${INPATH}\";" \
		-e "s;@EXETYPE\@;${EXECTYPE};" \
		bin/modpy.sh.in > "${T}/modpy.sh"

	insinto ${INPATH}
	doins -r modlib || die

	insinto ${INPATH}/bin
	doins -r bin/{lib,*top} || die
	exeinto ${INPATH}/bin
	doexe bin/{modslave.py,mod${MY_PV}_${EXECTYPE}} || die
	doexe "${T}/mod${MY_PV}" || die
	doexe "${T}/modpy.sh" || die
	dosym ${INPATH}/bin/mod${MY_PV} /opt/bin/mod${MY_PV} || die
	dosym ${INPATH}/bin/modpy.sh /opt/bin/modpy.sh || die

	exeinto ${INPATH}/lib/${EXECTYPE}/
	doexe lib/${EXECTYPE}/lib* || die
	dosym libmodeller.so.5 ${INPATH}/lib/${EXECTYPE}/libmodeller.so || die
	doexe src/swig/build/lib.linux-$(uname -m)-$(python_get_version)/_modeller.so || die

	dodoc README INSTALLATION || die
	if use doc; then
		dohtml doc/* || die
	fi
	if use examples; then
		insinto /usr/share/${PN}/
		doins -r examples || die
	fi

	dosym ${INPATH}/lib/${EXECTYPE}/_modeller.so \
		  $(python_get_sitedir)/_modeller.so || die
	dosym _modeller.so $(python_get_sitedir)/modeller.so || die
}

pkg_postinst() {
	python_mod_optimize "${INPATH}/"

	if [[ ! -e "${INPATH}/modlib/modeller/config.py" ]]; then
		echo install_dir = \"${INPATH}/\"> ${INPATH}/modlib/modeller/config.py
	fi

	if grep -q license ${INPATH}/modlib/modeller/config.py; then
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
	python_mod_cleanup "${INPATH}/"
	ewarn "This package leaves a license Key file in ${INPATH}/modlib/modeller/config.py"
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
				echo license = '"'$license_key1'"' >> "${INPATH}/modlib/modeller/config.py"
				einfo "Thank you!"
				break
			else
				eerror "Your license key entries do not match.  Try again."
			fi
		fi
	done
}
