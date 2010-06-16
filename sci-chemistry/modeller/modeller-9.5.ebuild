# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.6"

inherit distutils eutils versionator

MY_PV="${replace_all_version_separators v}"

DESCRIPTION="Homology or comparative modeling of protein three-dimensional structures"
SRC_URI="http://salilab.org/${PN}/${MY_PV}/${PN}-${MY_PV}.tar.gz"
HOMEPAGE="http://salilab.org/modeller/"

LICENSE="modeller"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

RESTRICT="mirror"

DEPEND=">=dev-lang/swig-1.3"
DEPEND=""

S="${WORKDIR}"/${MY_PN}-${MY_PV}



src_install(){
	local ver
	local in_path
	local exec_type

	ver=$(replace_all_version_separators v)
	in_path="${EPREFIX}"/opt/modeller${ver}

	case ${ARCH} in
		x86)	exec_type="i386-intel8";;
		amd64)	exec_type="x86_64-intel8";;
		*)		ewarn "Your arch "${ARCH}" does not appear supported at this time."||\
				die "Unsupported Arch";;
	esac

	sed \
		-e "s:EXECUTABLE_TYPE${MY_PV}=xxx:EXECUTABLE_TYPE${MY_PV}=${exec_type}:g" \
		-e "s:MODINSTALL${MY_PV}=xxx:MODINSTALL${MY_PV}=\"${in_path}\":g" \
		bin/modscript > "${T}/mod${MY_PV}"
	exeinto ${in_path}/bin/
	doexe "${T}/mod${MY_PV}" || die
	dosym ${in_path}/bin/mod${MY_PV} /opt/bin/mod${MY_PV} || die

	sed -e "s;@TOPDIR\@;\"${in_path}\";" \
		-e "s;@EXETYPE\@;${exec_type};" \
		bin/modpy.sh.in > "${T}/modpy.sh"
	doexe "${T}/modpy.sh" || die

	insinto ${in_path}
	doins -r modlib || die

	insinto ${in_path}/bin
	doins -r bin/{lib,*top} || die
	exeinto ${in_path}/bin
	doexe bin/{modslave.py,mod${MY_PV}_${exec_type}} || die

	exeinto ${in_path}/lib/${exec_type}/
	doexe lib/${exec_type}/lib* || die
	dosym libmodeller.so.3 ${in_path}/lib/${exec_type}/libmodeller.so || die
	doexe src/swig/build/lib.linux-$(uname -m)-$(python_get_version)/_modeller.so || die

	dodoc README INSTALLATION || die
	if use doc; then
		dohtml doc/* || die
	fi
	if use examples; then
		insinto /usr/share/${PN}/
		doins -r examples || die
	fi

	dosym ${in_path}/lib/${exec_type}/_modeller.so \
		  $(python_get_sitedir)/_modeller.so
}

pkg_postinst() {
	python_mod_optimize "${in_path}/"

	if [[ ! -e "${in_path}/modlib/modeller/config.py" ]]; then
		echo install_dir = '"'"${in_path}/"'"'> ${in_path}/modlib/modeller/config.py
	fi

	if grep -q license ${in_path}/modlib/modeller/config.py; then
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
	python_mod_cleanup "${in_path}/"
	ewarn "This package leaves a license Key file in ${in_path}/modlib/modeller/config.py"
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
				echo license = '"'$license_key1'"' >> "${in_path}/modlib/modeller/config.py"
				einfo "Thank you!"
				break
			else
				eerror "Your license key entries do not match.  Try again."
			fi
		fi
	done
}
