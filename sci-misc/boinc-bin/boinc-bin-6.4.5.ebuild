# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Don't forget to keep things in files dir in sync with normal boinc package!
#

EAPI="2"

inherit eutils

MY_PN="${PN//-bin/}"
MY_PV="${PV//./_}"
DESCRIPTION="The Berkeley Open Infrastructure for Network Computing"
HOMEPAGE="http://boinc.ssl.berkeley.edu/"
SRC_URI="
	amd64? ( http://${MY_PN}dl.ssl.berkeley.edu/dl/${MY_PN}_${PV}_x86_64-pc-linux-gnu.sh )
	x86? ( http://${MY_PN}dl.ssl.berkeley.edu/dl/${MY_PN}_${PV}_i686-pc-linux-gnu.sh )
	"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="X cuda"

DEPEND=""
RDEPEND="
	!sci-misc/boinc
	app-misc/ca-certificates
	dev-libs/openssl
	net-misc/curl
	sys-apps/util-linux
	sys-libs/zlib
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-2.1
		>=x11-drivers/nvidia-drivers-180.22
	)
	X? (
		media-libs/freeglut
		media-libs/jpeg
		x11-libs/wxGTK:2.8[X,opengl]
	)
	"

S="${WORKDIR}"/BOINC

LANGS="ar be bg ca cs da de el en_US es eu fi fr hr hu it ja lt lv nb nl pl pt
pt_BR ro ru sk sl sv_SE tr uk zh_CN zh_TW"
for LNG in ${LANGS}; do
	IUSE="${IUSE} linguas_${LNG}"
done

src_unpack() {
	local target
	use x86 && target="i686" || target="x86_64"
	cp "${DISTDIR}"/${MY_PN}_${PV}_${target}-pc-linux-gnu.sh "${WORKDIR}" \
		|| die "failed to prepare binary"
	cd "${WORKDIR}"
	sh ${MY_PN}_${PV}_${target}-pc-linux-gnu.sh &> /dev/null # annoying messages
}

src_install() {
	newinitd "${FILESDIR}"/${MY_PN}.init ${MY_PN}
	newconfd "${FILESDIR}"/${MY_PN}.conf ${MY_PN}
	# fancy X stuff
	if use X; then
		# icon
		newicon "${S}"/${MY_PN}mgr.48x48.png ${MY_PN}.png
		# desktop
		make_desktop_entry /opt/bin/boinc "${MY_PN}" ${MY_PN} "Education;Science" /var/lib/${MY_PN}
	fi
	# use correct path in scripts
	sed -i \
		-e "s:${S}:/opt/${MY_PN}/:g" \
		-e "s:./${MY_PN}mgr:/opt/${MY_PN}/${MY_PN}mgr:g" \
		run_manager || die "sed run_manager failed"
	# install binaries
	exeopts -m0755
	exeinto /opt/${MY_PN}
	doexe "${S}"/{${MY_PN},${MY_PN}cmd,${MY_PN}mgr,run_manager}
	fowners 0:${MY_PN} /opt/${MY_PN}/{${MY_PN},${MY_PN}cmd,${MY_PN}mgr,run_manager}
	# symlink the important ones to the /opt/bin/
	dosym /opt/${MY_PN}/run_manager /opt/bin/boinc
	# locale
	insopts -m0644
	insinto /opt/${MY_PN}/locale
	cd "${S}"/locale/
	for LNG in ${LINGUAS}; do
		doins -r "${LNG}"
	done
	# certificates
	dosym /etc/ssl/certs/ca-certificates.crt /opt/${MY_PN}/ca-bundle.crt
	# cuda
	use cuda && dosym /opt/cuda/lib/libcudart.so /opt/${MY_PN}/libcudart.so
}

pkg_preinst() {
	enewgroup ${MY_PN}
	if use cuda; then
		enewuser ${MY_PN} -1 -1 /var/lib/${MY_PN} "${MY_PN},video"
	else
		enewuser ${MY_PN} -1 -1 /var/lib/${MY_PN} "${MY_PN}"
	fi
}

pkg_postinst() {
	echo
	elog "You are using the binary distributed version."
	elog "The manager can be found at /opt/bin/${MY_PN}"
	elog
	elog "You need to attach to a project to do anything useful with ${MY_PN}."
	elog "You can do this by running /etc/init.d/${MY_PN} attach"
	elog "The howto for configuration is located at:"
	elog "http://${MY_PN}.berkeley.edu/anonymous_platform.php"
	elog
	# Add warning about the new password for the client, bug 121896.
	elog "If you need to use the graphical client the password is in:"
	elog "/var/lib/${MY_PN}/gui_rpc_auth.cfg"
	elog "Where /var/lib/ is default RUNTIMEDIR, that can be changed in:"
	elog "/etc/conf.d/${MY_PN}"
	elog "You should change this to something more memorable (can be even blank)."
	elog
	elog "Remember to launch init script before using manager. Or changing the password."
}
