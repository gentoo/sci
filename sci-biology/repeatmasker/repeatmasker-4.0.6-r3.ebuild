# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils perl-module

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
	dev-perl/Text-Soundex
	sci-biology/phrap
	sci-biology/repeatmasker-libraries
	sci-biology/rmblast
	!sci-biology/trf
	>=sci-biology/trf-bin-4.0.4
"

S="${WORKDIR}/RepeatMasker"

PATCHES=( "${FILESDIR}"/"${P}"__configure.patch )

src_configure() {
	sed \
		-e "s#/usr/bin/which#which#g" \
		-e "s#/usr/bin/perl#perl#g" \
		-i "${S}"/configure || die
	perl_set_version
	insinto ${VENDOR_LIB}
	sed -e "s#/usr/perl5/lib/#${VENDOR_LIB}/#g" -i "${S}"/configure || die
	# The below is wrong as it causes:
	# Enter path [ /var/tmp/portage/sci-biology/repeatmasker-4.0.1-r1/work/RepeatMasker ]:
	#  -- Building monolithic RM database...sh: /var/tmp/portage/sci-biology/repeatmasker-4.0.1-r1/image///usr/share/repeatmasker/Libraries/RepeatMasker.lib: No such file or directory
	# -e 's|> \($rmLocation/Libraries/RepeatMasker.lib\)|> '${D}'/\1|'
	sed -i -e 's/system( "clear" );//' "${S}/configure" || die
	mkdir -p "${ED}"/usr/share/repeatmasker/Libraries/ || die
	#
	# the below files is actually overwritten by buildRMLibFromEMBL.pl so the 'blah'
	# item does not get installed
	echo ">blah\natgc" > "${ED}"/usr/share/repeatmasker/Libraries/RepeatMasker.lib || die
	# below try to define paths to trf, cross_match, rmblast and nhmmer as search tools
	echo "
env
${S}
${EPREFIX}/opt/trf/bin
1
${EPREFIX}/usr/bin
Y
2
${EPREFIX}/usr/bin
Y
4
${EPREFIX}/usr/bin
Y
5" | "${S}"/configure || die "configure failed"
	sed -i -e "s|use lib $FindBin::RealBin;|use lib ${EPREFIX}/usr/share/${PN}/lib;|" \
		-e "s|.*\(taxonomy.dat\)|${EPREFIX}/usr/share/${PN}/Libraries/\1|" \
		-e "/$REPEATMASKER_DIR/ s|$FindBin::RealBin|${EPREFIX}/usr/share/${PN}|" \
		"${S}"/{DateRepeats,ProcessRepeats,RepeatMasker,DupMasker,RepeatProteinMask,RepeatMaskerConfig.pm,Taxonomy.pm} || die
}
# configure failed to 'cp RepeatMaskerConfig.tmpl RepeatMaskerConfig.pm'
# replace also /u1/local/bin/perl with proper Gentoo PATH

src_install() {
	exeinto /usr/share/${PN}
	for i in DateRepeats ProcessRepeats RepeatMasker DupMasker RepeatProteinMask; do
		doexe $i
		dosym ../share/${PN}/$i /usr/bin/$i
	done

	perl_set_version
	insinto "${VENDOR_LIB}"
	doins "${S}"/*.pm "${S}"/Libraries/*.pm
	# zap the supposedly misplaced RepeatAnnotationData.pm file
	rm -r "${S}"/Libraries/*.pm || die

	# if sci-biology/repeatmasker-libraries is installed prevent file collision
	# and do NOT install Libraries/RepeatMaskerLib.embl file which contains
	# a limited version of the file: 20110419-min
	rm -r Libraries/RepeatMaskerLib.embl || die
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
	einfo "${EPREFIX}/usr/share/${PN}/lib/RepeatMaskerConfig.pm"
	einfo "Supported search engines are:"
	optfeature "cross_match" sci-biology/phrap
	optfeature "rmblast" sci-biology/rmblast
	optfeature "nhmmer" >=sci-biology/hmmer-3.1
	einfo "abblast/wublast from http://blast.advbiocomp.com/licensing"
}
