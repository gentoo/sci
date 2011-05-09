# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/icm/icm-3.6.1i.ebuild,v 1.1 2010/05/21 12:36:43 alexxy Exp $

EAPI="3"

inherit eutils versionator

MY_PV=$(replace_version_separator 2 '-' )
MY_P="$PN-${MY_PV}"

DESCRIPTION="MolSoft LCC ICM Pro"
HOMEPAGE="http://www.molsoft.com/icm_pro.html"
SRC_URI="${MY_P}-linux.sh"

LICENSE="MolSoft"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="32bit 64bit"

RESTRICT="fetch"

DEPEND="!sci-chemistry/icm-browser
		app-arch/unzip
		amd64? (
			64bit? (
					media-libs/tiff-compat:3
					media-libs/libmng
					app-crypt/mit-krb5
					app-arch/bzip2
					media-libs/libpng:1.2
					x11-libs/libdrm
					x11-libs/libX11
					sys-apps/keyutils
			)
			32bit? (
					app-emulation/emul-linux-x86-compat
					app-emulation/emul-linux-x86-xlibs
			)
		)
		x86? (
				media-libs/tiff:3
				media-libs/libpng:1.2
				media-libs/libmng
				app-crypt/mit-krb5
				app-arch/bzip2
				x11-libs/libdrm
				x11-libs/libX11
				sys-apps/keyutils
		)"
RDEPEND="$DEPEND"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download ${SRC_URI} from "
	einfo "${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	unpack_makeself
	unpack ./data.tgz
	rm ./data.tgz
}

src_install () {
	instdir=/opt/icm
	dodir "${instdir}"
	dodir "${instdir}/licenses"
	cp -pPR * "${D}/${instdir}"
	rm "${D}/${instdir}/unzip"
	doenvd "${FILESDIR}/90icm" || die
	if use x86; then
		dosym "${instdir}/icm"  /opt/bin/icm || die
		rm  "${D}/${instdir}/icm64" || die
	elif use amd64; then
		if use 32bit; then
			dosym "${instdir}/icm"  /opt/bin/icm || die
		fi
		if use 64bit; then
			dosym "${instdir}/icm64" /opt/bin/icm64 || die
		fi
		if ! use 64bit; then
			rm  "${D}/${instdir}/icm64" || die
		fi
		if ! use 32bit; then
			rm "${D}/${instdir}/icm" || die
		fi
	fi
	dosym "${instdir}/txdoc"  /opt/bin/txdoc || die
	dosym "${instdir}/lmhostid"  /opt/bin/lmhostid || die
	# make desktop entry
	doicon "${FILESDIR}/${PN}.png"
	if use x86; then
		make_desktop_entry "icm -g" "ICM Pro" ${PN} Chemistry
	elif use amd64; then
		use 32bit && make_desktop_entry "icm -g" "ICM Pro (32bit)" ${PN} Chemistry
		use 64bit && make_desktop_entry "icm64 -g" "ICM Pro (64bit)" ${PN} Chemistry
	fi
}

pkg_postinst () {
	einfo
	einfo "Documentation can be found in ${instdir}/man/"
	einfo
	einfo "You will need to place your license in ${instdir}/licenses/"
	einfo

}
