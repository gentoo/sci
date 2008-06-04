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

LANGS="cs de es es_AR fi fr he id it nl no pl pt pt_BR ro ru sv tr"
for lang in ${LANGS}; do
	IUSE="${IUSE} linguas_${lang}"
done

S="${WORKDIR}/${P}/src"

src_unpack( ) {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-fix-icon-name.patch
	cd "${S}"
	# substitute translation file with a stripped one
	{
		echo "set(speedcrunch_TRANSLATIONS"
		local lang
		for lang in ${LANGS}; do
			use linguas_${lang} && echo "i18n/${lang}.qm"
			use linguas_${lang} || sed -i -e "s:books/${lang}::" CMakeLists.txt
		done
		echo ")"
	} > Translations.cmake
}

src_install() {
	cmake-utils_src_install
	cd ..
	dodoc ChangeLog ChangeLog.floatnum HACKING.txt LISEZMOI README TRANSLATORS
}

pkg_postinst() {
	elog "Help us to improve the ebuild"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=78113"
}
