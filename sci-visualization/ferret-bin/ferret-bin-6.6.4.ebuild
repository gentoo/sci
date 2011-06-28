# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils versionator

MY_PV=$(delete_all_version_separators "${PV}" )

MY_FER_ENV="fer_environment.v${MY_PV}.tar.gz"
MY_FER_EXE="fer_executables.v${MY_PV}.tar.gz"

DESCRIPTION="Ferret is an interactive computer visualization and analysis environment"
HOMEPAGE="http://ferret.pmel.noaa.gov/Ferret/"
SRC_URI="ftp://ftp.pmel.noaa.gov/ferret/pub/data/fer_dsets.tar.gz
	x86? ( ftp://ftp.pmel.noaa.gov/ferret/pub/linux_32_nc4/${MY_FER_ENV} -> x86${MY_FER_ENV}
	       ftp://ftp.pmel.noaa.gov/ferret/pub/linux_32_nc4/${MY_FER_EXE} -> x86${MY_FER_EXE} )
	amd64? ( ftp://ftp.pmel.noaa.gov/ferret/pub/x86_64-linux_nc4/${MY_FER_ENV} -> amd64${MY_FER_ENV}
	         ftp://ftp.pmel.noaa.gov/ferret/pub/x86_64-linux_nc4/${MY_FER_EXE} -> amd64${MY_FER_EXE} )"

LICENSE="PMEL-FERRET"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=app-crypt/mit-krb5-1.6.3-r6
	x11-base/xorg-server
	~virtual/libstdc++-3.3"

BASEDIR="/opt/ferret-bin"

src_unpack() {
	mkdir "${S}"
	cd "${S}"
	use x86 && unpack "x86${MY_FER_ENV}"
	use amd64 && unpack "amd64${MY_FER_ENV}"
	cd "${S}"/bin
	use x86 && unpack "x86${MY_FER_EXE}"
	use amd64 && unpack "amd64${MY_FER_EXE}"
	cd "${S}"
	mkdir data
	cd data
	unpack "fer_dsets.tar.gz"
}

src_install() {
	mkdir -p ext_func/libs
	mv bin/*.so ext_func/libs

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
