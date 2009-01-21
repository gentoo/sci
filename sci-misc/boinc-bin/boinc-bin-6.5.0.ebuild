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
IUSE="X"

RDEPEND="
	!sci-misc/boinc
	>=dev-libs/openssl-0.9.7
	>=net-misc/curl-7.15.5
	sys-apps/util-linux
	sys-libs/zlib
	X? ( x11-libs/wxGTK:2.8 )
	"
DEPEND="${RDEPEND}
	app-misc/ca-certificates
	X? (
		media-libs/freeglut
		media-libs/jpeg
		media-libs/mesa
		x11-libs/libX11
		x11-libs/libXmu
		x11-libs/libXt
		x11-proto/xproto
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
	cp "${DISTDIR}"/${MY_PN}_${PV}_${target}-pc-linux-gnu.sh "${WORKDIR}"
	cd "${WORKDIR}"
	sh ${MY_PN}_${PV}_${target}-pc-linux-gnu.sh
	# patch up certificates
	mkdir "${S}"/curl/
	ln -s /etc/ssl/certs/ca-certificates.crt "${S}"/curl/ca-bundle.crt
}

src_install() {
	dodir /var/lib/${MY_PN}
	newinitd "${FILESDIR}"/${MY_PN}.init ${MY_PN}
	newconfd "${FILESDIR}"/${MY_PN}.conf ${MY_PN}
	# fix ${PN}.conf file for binary package
	sed -i \
		-e "s:/usr/bin/${MY_PN}_client:/opt/${MY_PN}/${MY_PN}:g" \
		"${D}"/etc/conf.d/${MY_PN} || die "sed failed"
	if use X; then
		# icon
		newicon "${S}"/${MY_PN}mgr.48x48.png ${MY_PN}.png
		# desktop
		make_desktop_entry /opt/${MY_PN}/run_manager "${MY_PN}" ${MY_PN} "Education;Science" /var/lib/${MY_PN}
	fi
	# use correct path in scripts
	sed -i \
		-e "s:${S}:/var/lib/${MY_PN}:g" \
		-e "s:./${MY_PN}:/opt/${MY_PN}/${MY_PN}:g" \
		run_client || die "sed run_client failed"
	sed -i \
		-e "s:${S}:/var/lib/${MY_PN}:g" \
		-e "s:./${MY_PN}mgr:/opt/${MY_PN}/${MY_PN}mgr:g" \
		run_manager || die "sed run_manager failed"
	# install binaries
	exeopts -m0755
	exeinto /opt/${MY_PN}

	doexe "${S}"/{${MY_PN},${MY_PN}cmd,${MY_PN}mgr,run_client,run_manager}
	fowners 0:${MY_PN} /opt/${MY_PN}/{${MY_PN},${MY_PN}cmd,${MY_PN}mgr,run_client,run_manager}
	# locale
	mkdir -p "${D}"/opt/${MY_PN}/locale
	insopts -m0644
	insinto /opt/${MY_PN}/locale
	cd "${S}"/locale/
	for LNG in ${LINGUAS}; do
		doins -r "${LNG}"
	done
	dosym /opt/${MY_PN}/locale /var/lib/${MY_PN}/locale
	cd "${S}"
	dosym /etc/ssl/certs/ca-certificates.crt /var/lib/${MY_PN}/ca-bundle.crt
}

pkg_preinst() {
	enewgroup ${MY_PN}
	enewuser ${MY_PN} -1 -1 /var/lib/${MY_PN} ${MY_PN}
}

pkg_postinst() {
	echo
	elog "You are using the binary distributed version."
	elog "The manager can be found at /opt/${MY_PN}/run_manager"
	echo
	elog "You need to attach to a project to do anything useful with ${MY_PN}."
	elog "You can do this by running /etc/init.d/${MY_PN} attach"
	elog "${MY_PN} The howto for configuration is located at:"
	elog "http://${MY_PN}.berkeley.edu/anonymous_platform.php"
	echo
	# Add warning about the new password for the client, bug 121896.
	elog "If you need to use the graphical client the password is in"
	elog "/var/lib/${MY_PN}/gui_rpc_auth.cfg"
	elog "You should change this to something more memorable (can be blank)."
	echo
}
