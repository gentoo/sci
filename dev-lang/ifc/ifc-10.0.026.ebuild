# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator elisp-common rpm multilib

PID=787
PB=fc
DESCRIPTION="Intel FORTRAN 77/95 Compiler - Intel's optimized compiler for Linux"
HOMEPAGE="http://www.intel.com/software/products/compilers/flin/"

# everything below should not change between ifc and icc
PACKAGEID="l_${PB}_c_${PV}"
KEYWORDS="~amd64 ~ia64 ~x86"
SRC_URI="amd64? ( http://registrationcenter-download.intel.com/irc_nas/${PID}/${PACKAGEID}_intel64.tar.gz )
	ia64? ( http://registrationcenter-download.intel.com/irc_nas/${PID}/${PACKAGEID}_ia64.tar.gz )
	x86? ( http://registrationcenter-download.intel.com/irc_nas/${PID}/${PACKAGEID}_ia32.tar.gz )"

MAJOR=$(get_major_version ${PV})
MINOR=$(get_version_component_range 2 ${PV})
LICENSE="${PN}-${MAJOR}.${MINOR}"
SLOT="${MAJOR}.${MINOR}"

RESTRICT="test strip mirror"
IUSE="emacs"

RDEPEND="virtual/libc
	sys-devel/gcc"

if use x86; then
	MY_P="${PACKAGEID}_ia32"
elif use amd64; then
	MY_P="${PACKAGEID}_intel64"
elif use ia64; then
	MY_P="${PACKAGEID}_ia64"
fi
S="${WORKDIR}/${MY_P}"

pkg_setup() {
	# for amd64, the binary is x86 => ABI=x86
	has_multilib_profile && ABI="x86"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	local ext=
	use amd64 && ext=e
	INSTALL_DIR=/opt/intel/${PB}${ext}/${PV}

	# checking existence of idb
	if [[ -x "/opt/intel/idb${ext}/${PV}/bin/idb" ]]; then
		rm -f data/intel*idb*.rpm
	else
		INSTALL_IDB_DIR=/opt/intel/idb${ext}/${PV}
	fi

	for x in data/intel*.rpm; do
		einfo "Extracting $(basename ${x})..."
		rpm_unpack "${S}/${x}" || die "rpm_unpack ${x} failed"
	done

	einfo "Fixing paths and tagging"
	sed -i \
		-e "s|<INSTALLDIR>|${INSTALL_DIR}|g" \
		"${S}"/opt/intel/*/*/bin/* \
		|| die "sed fixing path failed"

	sed -i \
		-e "s|\<installpackageid\>|${PACKAGEID}|g" \
		-e "s|\<INSTALLTIMECOMBOPACKAGEID\>|${PACKAGEID}|g" \
		"${S}"/opt/intel/*/*/doc/*support \
		|| die "sed support file failed"
	chmod 644 "${S}"/opt/intel/*/*/doc/*support

}

src_install() {
	dodir /opt/intel
	cp -pPR "${S}"/opt/intel/${PB}* "${D}"/opt/intel || die "copying ${PN} failed"

	local env_file=05${PN}
	echo "PATH=${INSTALL_DIR}/bin" > ${env_file}
	echo "LDPATH=${INSTALL_DIR}/lib" >> ${env_file}
	echo "MANPATH=${INSTALL_DIR}/man" >> ${env_file}
	echo "INCLUDE=${INSTALL_DIR}/include" >> ${env_file}
	doenvd ${env_file} || die "doenvd ${env_file} failed"

	if [[ -n "${INSTALL_IDB_DIR}" ]]; then
		cp -pPR "${S}"/opt/intel/idb* "${D}"/opt/intel || die "copying debugger failed"
		local idb_env_file=06idb
		echo "PATH=${INSTALL_IDB_DIR}/bin" > ${idb_env_file}
		echo "MANPATH=${INSTALL_IDB_DIR}/man" >> ${idb_env_file}
		doenvd ${idb_env_file} || die "doenvd ${idb_env_file} failed"
		use emacs && \
			elisp-site-file-install "${S}${INSTALL_IDB_DIR}/bin/*.el"
	fi
}

pkg_postinst () {
	einfo "Make sure you have recieved the restrictive"
	einfo "non-commercial license ${PN} by registering at:"
	einfo ""
	einfo "You cannot run ${PN} without this license file."
	einfo "Read the website for more information on this license."
	einfo
	einfo "Documentation can be found in ${INSTALL_DIR}/doc"

	ewarn "Please perform \n\t env-update && source /etc/profile"
	ewarn "prior to using ${PN}."

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
