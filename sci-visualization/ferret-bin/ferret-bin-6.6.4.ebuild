# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils versionator

MY_PV=$(delete_all_version_separators "${PV}" )

MY_FER_ENV="fer_environment.v${MY_PV}.tar.gz"
MY_FER_EXE="fer_executables.v${MY_PV}.tar.gz"

DESCRIPTION="Analysis Tool for Gridded and Non-Gridded Data"
HOMEPAGE="http://ferret.pmel.noaa.gov/Ferret/"
SRC_URI="
	ftp://ftp.pmel.noaa.gov/ferret/pub/data/fer_dsets.tar.gz
	x86? (
		ftp://ftp.pmel.noaa.gov/ferret/pub/linux_32_nc4/${MY_FER_ENV} -> x86${MY_FER_ENV}
		ftp://ftp.pmel.noaa.gov/ferret/pub/linux_32_nc4/${MY_FER_EXE} -> x86${MY_FER_EXE} )
	amd64? (
		ftp://ftp.pmel.noaa.gov/ferret/pub/x86_64-linux_nc4/${MY_FER_ENV} -> amd64${MY_FER_ENV}
		ftp://ftp.pmel.noaa.gov/ferret/pub/x86_64-linux_nc4/${MY_FER_EXE} -> amd64${MY_FER_EXE} )"

LICENSE="PMEL-FERRET"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=app-crypt/mit-krb5-1.6.3-r6
	x11-base/xorg-server
	virtual/libstdc++:3.3"

BASEDIR="/opt/ferret-bin"

src_unpack() {
	mkdir "${S}" || die
	cd "${S}" || die
	use x86 && unpack "x86${MY_FER_ENV}"
	use amd64 && unpack "amd64${MY_FER_ENV}"

	cd "${S}"/bin || die
	use x86 && unpack "x86${MY_FER_EXE}"
	use amd64 && unpack "amd64${MY_FER_EXE}"

	mkdir "${S}"/data || die
	cd "${S}"/data || die
	unpack "fer_dsets.tar.gz"
}

src_install() {
	mkdir -p ext_func/libs || die
	mv bin/*.so ext_func/libs || die

	mkdir -p "${ED}/${BASEDIR}" || die
	mv "${S}"/* "${ED}/${BASEDIR}" || die

	doenvd "${FILESDIR}"/99ferret
}
