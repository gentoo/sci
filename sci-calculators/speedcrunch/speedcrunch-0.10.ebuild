# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils cmake-utils

DESCRIPTION="A fast and usable calculator for power users."
HOMEPAGE="http://speedcrunch.org/"
SRC_URI="http://speedcrunch.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/qt-4.2:4"

LANGS="es_AR de cs en es fi fr he id it nl no pl pt ro ru sv tr pt_BR"
for lang in ${LANGS}; do
	IUSE="${IUSE} linguas_${lang}"
done

S="${WORKDIR}/${P}/src"

src_unpack( ) {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-fix-icon-name.patch
}

src_install() {
	cmake-utils_src_install
	# install the translation files
	strip-linguas ${LANGS}
	if [[ -n ${LINGUAS} ]]; then
		einfo "Translations for the following languages will be installed:"
		einfo "${LINGUAS}"
		insinto /usr/share/${PN}/translations
		for lang in ${LINGUAS}; do
			doins i18n/${lang}.qm
		done
	fi

	doicon resources/speedcrunch.png
	make_desktop_entry ${PN} "SpeedCrunch"
	cd ..
	dodoc ChangeLog* HACKING.txt LISEZMOI PACKAGERS README TRANSLATORS
}

pkg_postinst() {
	elog "Help us to improve the ebuild"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=78113"
}
