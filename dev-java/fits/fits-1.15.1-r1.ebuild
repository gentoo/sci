# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-utils-2

DESCRIPTION="Java library for FITS input/output"
HOMEPAGE="http://fits.gsfc.nasa.gov/fits_libraries.html#java_tam"

SRC_URI="http://heasarc.gsfc.nasa.gov/docs/heasarc/${PN}/java/v1.0/v${PV}/${PN}.jar -> ${P}.jar"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.5"

src_unpack() {
	:;
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	java-pkg_newjar "${DISTDIR}/${P}.jar" "${PN}.jar"
}
