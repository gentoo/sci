# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator rpm multilib

PID=721
PB=${PN}
DESCRIPTION="Intel(R) Integrated Performance Primitive library for multimedia and data processing"
HOMEPAGE="http://developer.intel.com/software/products/ipp/"

KEYWORDS="~amd64 ~x86"
SRC_URI="amd64? ( http://registrationcenter-download.intel.com/irc_nas/${PID}/l_${PB}_em64t_p_${PV}.tgz )
	x86? ( http://registrationcenter-download.intel.com/irc_nas/${PID}/l_${PB}_ia32_p_${PV}.tgz )"

MAJOR=$(get_major_version ${PV})
MINOR=$(get_version_component_range 2 ${PV})

SLOT="${MAJOR}.${MINOR}"
LICENSE="${PN}-${MAJOR}.${MINOR}"

IUSE=""
RESTRICT="strip mirror"

pkg_setup() {
	# setting up license
	[[ -z "${IPP_LICENSE}" ]] && [[ -d /opt/intel/licenses ]] && \
		IPP_LICENSE="$(find /opt/intel/licenses -name *IPP*.lic)"

	if  [[ -z "${IPP_LICENSE}" ]]; then
		eerror "Did not find any valid ipp license."
		eerror "Please locate your license file and run:"
		eerror "\t IPP_LICENSE=/my/license/dir emerge ${PN}"
		eerror "or place your license in /opt/intel/licenses"
		eerror "Hint: the license file is in the email Intel sent you"
		die "setup ipp license failed"
	fi
}

src_unpack() {

	ewarn
	ewarn "Intel ${PN} requires at least 300Mb of disk space"
	ewarn "Make sure you have enough in ${PORTAGE_TMPDIR}, /tmp and in /opt"
	ewarn
	unpack ${A}

	cd l_${PB}_*_${PV}/install
	local arch=
	if use amd64; then
		arch=em64t
	elif use x86; then
		arch=ia32
	elif use ia64; then
		arch=ia64
	fi
	# need to make a file to install non-interactively.
	# to produce such a file, first do it interactively
	# tar xf l_*; ./install.sh --duplicate ipp.ini;
	# the file will be instman/ipp.ini

	# binary blob extractor installs crap in /opt/intel
	addwrite /opt/intel
	cp ${IPP_LICENSE} ${WORKDIR}/
	IPP_LICENSE="$(basename ${IPP_LICENSE})"
	cat > ipp.ini << EOF
[IPP_${arch}]
EULA_ACCEPT_REJECT=ACCEPT
FLEXLM_LICENSE_LOCATION=${WORKDIR}/${IPP_LICENSE}
INSTALLMODE_${arch}=NONRPM
INSTALL_DESTINATION=${S}
EOF
	einfo "Extracting ..."
	./install \
		--silent ${PWD}/ipp.ini \
		--log log.txt &> /dev/null

	if [[ -z $(find "${S}" -name libippmmx.so) ]]; then
		eerror "could not find extracted files"
		eerror "see ${PWD}/log.txt to see why"
		die "extracting failed"
	fi

	rm -rf "${WORKDIR}"/l_*
	INSTALL_DIR=/opt/intel/${PN}/${MAJOR}.${MINOR}/${arch}
}

src_compile() {
	einfo "Binary package, nothing to compile"
}

src_test() {
	cd "${S}"/tools/perfsys
	for t in ps_ippcce* ps_vm*; do
		LD_LIBRARY_PATH="${S}"/sharedlib ./${t} -B || die "test ${t} failed"
	done
}

src_install() {
	dodir ${INSTALL_DIR}
	# install license
	if  [ ! -f "/opt/intel/licenses/${IPP_LICENSE}" ]; then
		insinto /opt/intel/licenses
		doins ${WORKDIR}/${IPP_LICENSE}
	fi

	einfo "Copying all files"
	cp -pPR "${S}"/* "${D}${INSTALL_DIR}"

	local env_file=36ipp
	echo "LDPATH=${INSTALL_DIR}/sharedlib" > ${env_file}
	echo "INCLUDE=${INSTALL_DIR}/include" >> ${env_file}
	doenvd ${env_file} || die "doenvd ${env_file} failed"
}
