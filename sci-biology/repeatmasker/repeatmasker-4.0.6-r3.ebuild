# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils perl-functions

MY_PV=${PV//\./-}

DESCRIPTION="Screen DNA sequences for interspersed repeats and low complexity DNA"
HOMEPAGE="http://repeatmasker.org/"
SRC_URI="http://www.repeatmasker.org/RepeatMasker-open-${MY_PV}.tar.gz"

LICENSE="OSL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+phrap -rmblast +hmmer"

DEPEND=">=dev-lang/perl-5.8
	>=sci-biology/trf-4.0.4
	phrap? ( sci-biology/phrap )
	rmblast? ( sci-biology/rmblast )
	hmmer? ( sci-biology/hmmer )"
#	wublast? ( sci-biology/wublast )
RDEPEND="dev-perl/Text-Soundex"
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
	local CONF=( x env ${S} "${EPREFIX}"/opt/bin )
	use phrap && CONF+=( 1 "${EPREFIX}"/usr/bin Y )
	use rmblast && CONF+=( 2 "${EPREFIX}"/usr/bin Y )
#	use wublast && CONF+=( 3 "${EPREFIX}"/usr/bin Y ) # no ebuild avail
	use hmmer && CONF+=( 4 "${EPREFIX}"/usr/bin Y )
	CONF+=( 5 )
	printf '%s\n' "${CONF[@]}" | "${S}/configure" || die "configure failed"

	sed -i -e "/use lib/s|\"\$FindBin::RealBin|\"${EPREFIX}/usr/share/${PN}/lib|" \
		-e "/use lib/s|\$FindBin::RealBin|\"${EPREFIX}/usr/share/${PN}/lib\"|" \
		-e "/\$REPEATMASKER_DIR/ s|\$FindBin::RealBin|${EPREFIX}/usr/share/${PN}|" \
		"${S}"/{DateRepeats,ProcessRepeats,RepeatMasker,DupMasker,RepeatProteinMask,RepeatMaskerConfig.pm,Taxonomy.pm} || die
}

src_install() {
	exeinto /usr/share/${PN}
	for i in DateRepeats ProcessRepeats RepeatMasker DupMasker RepeatProteinMask; do
		doexe $i
		dosym /usr/share/${PN}/$i /usr/bin/$i
	done

#	dodir /usr/share/${PN}/lib
#	insinto /usr/share/${PN}/lib
	perl_set_version
	insinto /usr/lib/perl5/${PERL_VERSION}
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
	einfo "/usr/share/${PN}/lib/RepeatMaskerConfig.pm"
	einfo "Supported search engines are:"
	einfo "cross_match from sci-biology/phrap"
	einfo "rmblast from sci-biology/rmblast"
	einfo "nhmmer from >=sci-biology/hmmer-3.1"
	einfo "abblast/wublast from http://blast.advbiocomp.com/licensing"
}
