# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python

MY_P="arp_warp_${PV}"
DESCRIPTION="ARP/wARP is a software for improvement and interpretation of crystallographic electron density maps"
SRC_URI="${MY_P}.tar.gz"
HOMEPAGE="http://www.embl-hamburg.de/ARP/"
LICENSE="ArpWarp"
RESTRICT="fetch"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RDEPEND="app-shells/tcsh
	 >=sci-chemistry/ccp4-6
	 sys-apps/gawk
	 >=dev-lang/python-2.4"
DEPEND=""
S="${WORKDIR}/${MY_P}"

pkg_nofetch(){
	elog "Fill out the form at http://www.embl-hamburg.de/ARP/"
	elog "and place ${A} in ${DISTDIR}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-setup.patch
	epatch "${FILESDIR}"/${PV}-source-ccp4-if-needed.patch
}

src_install(){
	python_version
	m_type=$(uname -m)
	os_type=$(uname)

	insinto /opt/${PN}/byte-code/python-${PYVER}
	doins "${S}"/flex-wARP-src-261/*py

	exeinto /opt/${PN}/bin/bin-${m_type}-${os_type}
	doexe "${S}"/bin/bin-${m_type}-${os_type}/* && \
	doexe "${S}"/share/*sh || die

	insinto /opt/${PN}/bin/bin-${m_type}-${os_type}
	doins "${S}"/share/*{gif,XYZ,bash,csh,dat,lib,tbl,llh} || die

	insinto /etc/profile.d/
	newins "${S}"/share/arpwarp_setup_base.csh 90arpwarp_setup.csh && \
	newins "${S}"/share/arpwarp_setup_base.bash 90arpwarp_setup.sh || die

	dodoc "${S}"/README
	dohtml -r "${S}"/manual/*
	insinto /usr/share/doc/${PF}
	doins -r "${S}"/{examples,ARP_wARP_CCP4I6.tar.gz}
}

pkg_postinst(){
	python_mod_optimize "${ROOT}"/opt/${PN}/byte-code/python-${PYVER}

	testcommand=$(echo 3 2 | awk '{printf"%3.1f",$1/$2}')
	if [ $testcommand == "1,5" ];then
	  ewarn "*** ERROR ***"
	  ewarn "   3/2=" $testcommand
	  ewarn "Invalid decimal separator (must be ".")"
	  ewarn "You need to set this correctly!!!"
	  ewarn
	  ewarn "One way of setting the decimal separator is:"
	  ewarn "setenv LC_NUMERIC C' in your .cshrc file"
	  ewarn "\tor"
	  ewarn "export LC_NUMERIC=C' in your .bashrc file"
	  ewarn "Otherwise please consult your system manager"
	  epause 10
	fi

	grep -q sse2 /proc/cpuinfo || einfo "The CPU is lacking SSE2! You should use the cluster at EMBL-Hamburg."
	einfo
	elog "The ccp4 interface file could be found in /usr/share/doc/"${P}
	elog "To install, run ccp4i as root, navigate to System Administration,"
	elog "Install/uninstall tasks, then choose ARP_wARP_CCP4I6.tar.gz."
}

pkg_postrm() {
	python_mod_cleanup "${ROOT}"/opt/${PN}/byte-code/python-${PYVER}
}
