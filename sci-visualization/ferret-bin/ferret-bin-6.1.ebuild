# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_PV=${PV/\./}

DESCRIPTION="Ferret is an interactive computer visualization and analysis environment"
HOMEPAGE="http://ferret.pmel.noaa.gov/Ferret/"
SRC_URI="ftp://ftp.pmel.noaa.gov/ferret/pub/data/fer_dsets.tar.gz
	amd64? ( ftp://ftp.pmel.noaa.gov/ferret/pub/x86_64-linux/previous_versions/fer_environment.${MY_PV}.tar.Z  -> fer_environment_x86_64.${MY_PV}.tar.Z
	         ftp://ftp.pmel.noaa.gov/ferret/pub/x86_64-linux/previous_versions/fer_executables.${MY_PV}.tar.Z -> fer_executables_x86_64.${MY_PV}.tar.Z )
	x86? ( ftp://ftp.pmel.noaa.gov/ferret/pub/linux_32/previous_versions/fer_environment.v${MY_PV}.tar.Z -> fer_environment_x86.${MY_PV}.tar.Z
	       ftp://ftp.pmel.noaa.gov/ferret/pub/linux_32/previous_versions/fer_executables.v${MY_PV}.tar.Z -> fer_executables_x86.${MY_PV}.tar.Z )"

LICENSE="PMEL-FERRET"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=app-crypt/mit-krb5-1.6.3-r6
	x11-base/xorg-server"

BASEDIR="/opt/ferret-bin"


src_unpack() {
	mkdir "${S}"
	cd "${S}"
	use amd64 && unpack "fer_environment_x86_64.${MY_PV}.tar.Z"
	use x86 && unpack "fer_environment_x86.${MY_PV}.tar.Z"
	cd "${S}"/bin
	use amd64 && unpack "fer_executables_x86_64.${MY_PV}.tar.Z"
	use x86 && unpack "fer_executables_x86.${MY_PV}.tar.Z"
	cd "${S}"
	mkdir data
	cd data
	unpack "fer_dsets.tar.gz"
}


src_install() {
	mkdir -p "${D}/${BASEDIR}"
	mv "${S}"/* "${D}/${BASEDIR}"
	doenvd "${FILESDIR}"/99ferret
}


pkg_postinst() {
	env-update
}


pkg_postrm() {
	env-update
}

