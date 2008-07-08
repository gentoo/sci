# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_PV=$(replace_all_version_separators '-')

DESCRIPTION="Screen DNA sequences for interspersed repeats and low complexity DNA"
HOMEPAGE="http://repeatmasker.org/"
SRC_URI="http://www.repeatmasker.org/RepeatMasker-open-${MY_PV}.tar.gz"

LICENSE="OSL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="sci-biology/phrap
	>=sci-biology/repeatmasker-libraries-20080611"

S="${WORKDIR}/RepeatMasker"

src_compile() {
	sed -i -e 's/system( "clear" );//' \
		-e 's|> \($rmLocation/Libraries/RepeatMasker.lib\)|> '${D}'/\1|' "${S}/configure" || die
	echo "
/usr/bin
/usr/share/${PN}
/usr/bin
1
/usr/bin
Y
4" | "${S}/configure" || die "configure failed"
	sed -i '/$REPEATMASKER_DIR/ s|$FindBin::RealBin|/usr/share/'${PN}'|' "${S}/RepeatMaskerConfig.pm" || die
	sed -i 's|use lib $FindBin::RealBin;|use lib "/usr/share/'${PN}'/lib";|' "${S}"/{DateRepeats,ProcessRepeats,RepeatMasker} || die
}

src_install() {
	dobin DateRepeats ProcessRepeats RepeatMasker

	dodir /usr/share/${PN}/lib
	insinto /usr/share/${PN}/lib
	doins "${S}"/*.pm

	insinto /usr/share/${PN}
	doins -r util Matrices
	keepdir /usr/share/${PN}/Libraries

	dodoc README INSTALL repeatmasker.help daterepeats.help
}
