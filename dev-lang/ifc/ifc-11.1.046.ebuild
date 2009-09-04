# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit rpm versionator check-reqs

PB=cprof
PACKAGEID="l_${PB}_p_${PV}"
RELEASE="$(get_version_component_range 1-2)"
BUILD="$(get_version_component_range 3)"
PID=1539

DESCRIPTION="Intel FORTRAN compiler suite for Linux"
HOMEPAGE="http://www.intel.com/software/products/compilers/clin/"
SRC_COM="http://registrationcenter-download.intel.com/irc_nas/${PID}/${PACKAGEID}"
SRC_URI="amd64? ( ${SRC_COM}_intel64.tgz )
	ia64? ( ${SRC_COM}_ia64.tgz )
	x86?  ( ${SRC_COM}_ia32.tgz )"

LICENSE="Intel-SDP"
SLOT="0"
IUSE="idb mkl"
KEYWORDS="~amd64 ~ia64 ~x86"

RESTRICT="mirror strip binchecks"

DEPEND=""
RDEPEND="~virtual/libstdc++-3.3
	amd64? ( app-emulation/emul-linux-x86-compat )
	idb? ( >=virtual/jre-1.5 )"

DESTINATION="${ROOT}opt/intel/Compiler/${RELEASE}/${BUILD}"

pkg_setup() {
	CHECKREQS_MEMORY=512
	CHECKREQS_DISK_BUILD=1024
	check_reqs
	IARCH=ia32
	use amd64 && IARCH=intel64
	use ia64 && IARCH=ia64
}

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/l_* "${S}"
	cd "${S}"
	use idb || rm -f rpm/*idb*.rpm
	use mkl || rm -f rpm/*mkl*.rpm
	if has_version "~dev-lang/icc-${PV}"; then
		rm -f rpm/*cprolib*.rpm
		use idb && built_with_use dev-lang/icc idb && rm -f rpm/*idb*.rpm
		use mkl && built_with_use dev-lang/icc mkl && rm -f rpm/*mkl*.rpm
	fi
	cd "${S}"
	for x in rpm/intel*.rpm; do
		einfo "Extracting $(basename ${x})..."
		rpm_unpack ${x} || die "rpm_unpack ${x} failed"
	done
}

src_prepare() {
	# from the PURGE_UB804_FNP in pset/install_cc.sh
	# rm -f "${DESTINATION}"/lib/*/*libFNP.so || die

	# extract the tag function from the original install
	sed -n \
		-e "s|find \$DESTINATION|find ${S}${DESTINATION}|g" \
		-e '/^UNTAG_CFG_FILES[[:space:]]*(/,/^}/p' \
		pset/install_cc.sh > tag.sh || die
	# fix world writeable files
	use mkl && chmod 644 \
		"${S}${DESTINATION}"/mkl/tools/{environment,builder}/* \
		"${S}${DESTINATION}"/mkl/tools/plugins/*/*
}

src_install() {
	einfo "Tagging"
	. ./tag.sh
	UNTAG_CFG_FILES

	keepdir /opt/intel/licenses
	einfo "Copying files"
	dodir "${DESTINATION}"
	cp -pPR \
		"${S}/${DESTINATION}"/* \
		"${D}/${DESTINATION}"/ \
		|| die "Copying ${PN} failed"

	cat > 05ifc <<-EOF
		PATH=${DESTINATION}/bin/${IARCH}
		LDPATH=${DESTINATION}/lib/${IARCH}
		NLSPATH="${DESTINATION}/lib/locale/en_US/%N"
		MANPATH=${DESTINATION}/man/en_US
	EOF
	doenvd 05ifc || die "doenvd 05ifc failed"
	if use idb; then
		cat > 06idb <<-EOF
			NLSPATH=${DESTINATION}/idb/${IARCH}/locale/%l_%t/%N
		EOF
		doenvd 06idb || die "doenvd 06idb failed"
		dosym ../../common/com.intel.debugger.help_1.0.0 \
			${DESTINATION}/idb/gui/${IARCH}/plugins
	fi
	if use mkl; then
		cat > 35mkl <<-EOF
			MKLROOT=${DESTINATION}/mkl
			LDPATH=\${MKLROOT}/lib/${IARCH}
			LIB=\${MKLROOT}/lib
			LIBRARY_PATH=\${MKLROOT}/lib/${IARCH}
			MANPATH=\${MKLROOT}/man/en_US
			CPATH=\${MKLROOT}/include
			FPATH=\${MKLROOT}/include
			NLSPATH=\${MKLROOT}/lib/${IARCH}/locale/%l_%t/%N
		EOF
		doenvd 35mkl || die "doenvd 35mkl failed"
	fi
}

pkg_postinst() {
	env-update && source "${ROOT}"etc/profile
	elog "Make sure you have recieved the an Intel license."
	elog "To receive a non-commercial license, you need to register at:"
	elog "http://software.intel.com/en-us/articles/non-commercial-software-development/"
	elog "Install the license file into ${ROOT}/opt/intel/licenses."
}
