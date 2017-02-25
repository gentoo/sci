# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs versionator java-pkg-2

# MY_PV=$(replace_all_version_separators '-')
MY_PV="oboedit_2_1_1-b6"
MY_VER="2.1.1-b6"
MY_PV=$(replace_all_version_separators '-')

DESCRIPTION="Java-based editor optimized for the OBO biological ontology file format"
HOMEPAGE="http://www.oboedit.org/"
SRC_URI="
	http://downloads.sourceforge.net/project/geneontology/OBO-Edit%202%20%5BLatest%20versions%5D/${MY_VER}/${MY_PV}_unix_install4j.sh -> ${PN}_unix_install4j-${PV}.sh
	http://sourceforge.net/projects/geneontology/files/OBO-Edit%202%20%5BLatest%20versions%5D/${MY_PV}/ReleaseNotes-${MY_VER}.txt -> ${PN}_ReleaseNotes-${PV}.txt"

LICENSE="OBO-Edit" # Artistic-like
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/rpm2targz"
RDEPEND="virtual/jre"

S="${WORKDIR}"

pkg_setup() {
	einfo "Fixing java access violations ..."
	# learned from bug #387227
	# opened a bug #402507 to get this .systemPrefs directory pre-created for everybody
	addpredict /opt/icedtea-bin-7.2.0/jre/.systemPrefs
	addpredict /usr/local/bin/OBO-Edit
}

src_prepare(){
	dodir /opt/OBO-Edit2/.install4j /usr/bin

	# /var/tmp/portage/sci-biology/OBO-Edit-2.1.1.6/image//opt/OBO-Edit2/.install4j/response.varfile
	sed -e "s#\"\${D}\"#"${D}"#g" "${FILESDIR}"/response.varfile | \
	sed -e "s#\"\${TMPDIR}\"#"${TMPDIR}"#g" | \
	sed -e "s@sys.symlinkDir=/usr/local/bin@#sys.symlinkDir=/usr/local/bin@" \
	> "${D}"/opt/OBO-Edit2/.install4j/response.varfile || die "sed failed"
	cp -r "${D}"/opt/OBO-Edit2/.install4j "${TMPDIR}" || die

	# for user root install4j writes into /opt/icedtea-bin-7.2.0/jre/.systemPrefs or whatever it
	# found via JAVA_HOME or similar variables
	# for other users it writes into $HOME/.java/.userPrefs/

	# trick setting -Djava.util.prefs.systemRoot="${TMPDIR}" does not work
	sed \
		-e "s@/bin/java\" -Dinstall4j.jvmDir=\"\$app_java_home\"@/bin/java\" -Duser.home="${TMPDIR}" -Dinstall4j.jvmDir="${TMPDIR}" -Dsys.symlinkDir="${D}"usr/bin -Djava.util.prefs.systemRoot="${TMPDIR}"@" \
		-i "${DISTDIR}"/"${PN}"_unix_install4j-"${PV}".sh \
		|| die "failed to set userHome and jvmDir where JAVA .systemPrefs can be found"

	chmod u+rx "${DISTDIR}"/"${PN}"_unix_install4j-"${PV}".sh || die
}

src_install(){
	# it looks install4j removes the target installation direcotry before writing into it :((
	#
	# cat "${TMPDIR}"/.install4j/response.varfile
	# chmod a-w "${TMPDIR}"/.install4j/response.varfile

	INSTALL4J_KEEP_TEMP="yes" \
		HOME="${TMPDIR}" \
		sh "${DISTDIR}"/"${PN}"_unix_install4j-"${PV}".sh -q \
		--varfile="${TMPDIR}"/.install4j/response.varfile \
		--destination="${D}"/opt/OBO-Edit2 \
		-dir "${D}"/opt/OBO-Edit2 \
		|| die "Failed to run the self-extracting ${DISTDIR}/${PN}_unix_install4j-${PV}.sh file"

	find . -name firstrun -delete || die

	esvn_clean

	dodoc "${DISTDIR}"/"${PN}"_ReleaseNotes-"${PV}".txt

	echo "PATH=/opt/OBO-Edit2" > 99OBO-Edit || die
	doenvd 99OBO-Edit
}
