# Copyright 1999-2019 Gentoo Authors
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
IUSE="phrap rmblast hmmer wublast"
# RepeatMaskerConfig.pm says:
#   Default search tool can be one of "hmmer", "crossmatch", "wublast", "decypher" or "ncbi".
#   Upstream uses "hmmer" as the default.

DEPEND=">=dev-lang/perl-5.8"
RDEPEND="
	<=sci-biology/repeatmasker-libraries-20160829
	dev-perl/Text-Soundex
	phrap? ( !hmmer? ( !rmblast? ( !wublast? ( sci-biology/phrap ) ) ) )
	rmblast? ( !hmmer? ( !phrap? ( !wublast? ( sci-biology/rmblast ) ) ) )
	hmmer? ( !phrap? ( !wublast? ( !rmblast? ( sci-biology/hmmer ) ) ) )
	!sci-biology/trf
	>=sci-biology/trf-bin-4.0.4
"
# wublast? ( sci-biology/wublast || sci-biology/abblast )
# ncbi? ( would that be ncbi-tools++ or ncbi-blast+ ) ???

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
	#
	local my_crossmatch=`which cross_match 2>/dev/null`
	local my_rmblastn=`which rmblastn 2>/dev/null`
	local my_hmmer=`which nhmmscan 2>/dev/null`
	local my_wublast=`which xdformat 2>/dev/null` # actually configure looks for 'setdb' executable
	# configure is inconsistent at first, we must pass even a wrong path for cross_match, rmblastn, hmmer otherwise it enters a loop
	# but, for wublast we must pass in an empty string otherwise it looks for 'setdb' executable in the non-existing directory and enters a loop
	if [ "$my_crossmatch" != '.' ]; then local crossmatchdir=`dirname "$my_crossmatch"` else local crossmatchdir="${EPREFIX}/usr/bin"; fi
	if [ "$my_rmblastn" != '.' ]; then local rmblastdir=`dirname "$my_rmblastn"` else local rmblastdir="${EPREFIX}/usr/bin"; fi
	if [ "$my_hmmer" != '.' ]; then local hmmerdir=`dirname "$my_hmmer"` else local hmmerdir="${EPREFIX}/usr/bin"; fi
	if [ "$my_wublast" != '.' ]; then local wublastdir=`dirname "$my_wublast"` else local wublastdir=""; fi
	echo "crossmatchdir=${crossmatchdir} rmblastdir=${rmblastdir} wublastdir=${wublastdir} hmmerdir=${hmmerdir}"
	# pick the preferred-one
	local CONF=( x env ${S} "${EPREFIX}"/opt/bin )
	if use phrap; then
		CONF+=( 1 "${crossmatchdir}" Y )
	else
		CONF+=( 1 "${crossmatchdir}" N )
	fi
	if use rmblast; then
		CONF+=( 2 "${rmblastdir}" Y )
	else
		CONF+=( 2 "${rmblastdir}" N )
	fi
	if use wublast; then
		# no ebuild available but pick anything from PATH
		CONF+=( 3 "${wublastdir}" Y )
	else
		CONF+=( 3 "${wublastdir}" N )
	fi
	if use hmmer; then
		CONF+=( 4 "${hmmerdir}" Y )
	else
		CONF+=( 4 "${hmmerdir}" N )
	fi
	CONF+=( 5 )
	echo "Will feed configure with: ${CONF[@]}"
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
	cd "${S}" || die
	einfo "RepeatMasker provides bundled human repeats database from"
	einfo "    Dfam-1.0 database www.dfam.org"
	einfo "You can configure which search search engine is to be used and"
	einfo "Current default search engine defined in"
	einfo "    ${EPREFIX}${VENDOR_LIB}/RepeatMaskerConfig.pm is:"
	einfo `grep 'DEFAULT_SEARCH_ENGINE =' RepeatMaskerConfig.pm`
	einfo "\nSupported search engines are:"
	optfeature "cross_match" sci-biology/phrap
	optfeature "rmblast" sci-biology/rmblast
	optfeature "nhmmer" \>=sci-biology/hmmer-3.1
	einfo "abblast/wublast from http://blast.advbiocomp.com/licensing"
	einfo "\nThe repeatmasker-libraries-20160829 (RepBase 21.12) was the last"
	einfo "version compatible with <repeatmasker-4.0.7"
}
