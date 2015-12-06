# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_PV=${PV//\./-}

DESCRIPTION="Screen DNA sequences for interspersed repeats and low complexity DNA"
HOMEPAGE="http://repeatmasker.org/"
SRC_URI="http://www.repeatmasker.org/RepeatMasker-open-${MY_PV}.tar.gz"

LICENSE="OSL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.8"
RDEPEND="
	sci-biology/rmblast
	>=sci-biology/trf-4.0.4
	sci-biology/repeatmasker-libraries
	sci-biology/phrap"
# dev-perl/Text-Soundex see bug #566740

S="${WORKDIR}/RepeatMasker"

src_prepare(){
	epatch "${FILESDIR}"/"${P}"__configure.patch
}

src_configure() {
	# The below is wrong as it causes:
	# Enter path [ /var/tmp/portage/sci-biology/repeatmasker-4.0.1-r1/work/RepeatMasker ]: 
	#  -- Building monolithic RM database...sh: /var/tmp/portage/sci-biology/repeatmasker-4.0.1-r1/image///usr/share/repeatmasker/Libraries/RepeatMasker.lib: No such file or directory
	# -e 's|> \($rmLocation/Libraries/RepeatMasker.lib\)|> '${D}'/\1|'
	sed -i -e 's/system( "clear" );//' "${S}/configure" || die
	mkdir -p "${D}"/usr/share/repeatmasker/Libraries/ || die
	#
	# the below files is actually overwritten by buildRMLibFromEMBL.pl so the 'blah'
	# item does not get installed
	echo ">blah\natgc" > "${D}"/usr/share/repeatmasker/Libraries/RepeatMasker.lib || die
	# below try to define paths to trf, cross_match, rmblast and nhmmer as search tools
	echo "
env
${S}
/opt/bin
1
/usr/bin
Y
2
/usr/bin
Y
4
/usr/bin
Y
5" | "${S}/configure" || die "configure failed"
	sed -i -e 's|use lib $FindBin::RealBin;|use lib "/usr/share/'${PN}'/lib";|' \
		-e 's|".*\(taxonomy.dat\)"|"/usr/share/'${PN}'/Libraries/\1"|' \
		-e '/$REPEATMASKER_DIR/ s|$FindBin::RealBin|/usr/share/'${PN}'|' \
		"${S}"/{DateRepeats,ProcessRepeats,RepeatMasker,DupMasker,RepeatProteinMask,RepeatMaskerConfig.pm,Taxonomy.pm} || die
}
# configure failed to 'cp RepeatMaskerConfig.tmpl RepeatMaskerConfig.pm'
# replace also /u1/local/bin/perl with proper Gentoo PATH

src_install() {
	exeinto /usr/share/${PN}
	for i in DateRepeats ProcessRepeats RepeatMasker DupMasker RepeatProteinMask; do
		doexe $i || die
		dosym /usr/share/${PN}/$i /usr/bin/$i || die
	done

	dodir /usr/share/${PN}/lib
	insinto /usr/share/${PN}/lib
	doins "${S}"/*.pm "${S}"/Libraries/*.pm
	rm -rf "${S}"/Libraries/*.pm # zap the supposedly misplaced RepeatAnnotationData.pm file

	# if sci-biology/repeatmasker-libraries is installed prevent file collision
	# and do NOT install Libraries/RepeatMaskerLib.embl file which contains
	# a limited version of the file: 20110419-min
	rm -rf Libraries/RepeatMaskerLib.embl
	insinto /usr/share/${PN}
	doins -r util Matrices Libraries *.help
	keepdir /usr/share/${PN}/Libraries

	dodoc README INSTALL *.help
}

pkg_postinst(){
	einfo "RepeatMasker provides bundled human repeats database"
	einfo "from Dfam-1.0 database www.dfam.org"
	einfo "You can configure which search search engine is to be used and"
	einfo "PATHs to the search binaries are defined in"
	einfo "/usr/share/${PN}/lib/RepeatMaskerConfig.pm"
	einfo "Supported search engines are:"
	einfo "cross_match from sci-biology/phrap"
	einfo "rmblast from sci-biology/rmblast"
	einfo "nhmmer from >=sci-biology/hmmer-3.1"
	einfo "abblast/wublast from http://blast.advbiocomp.com/licensing"
}
