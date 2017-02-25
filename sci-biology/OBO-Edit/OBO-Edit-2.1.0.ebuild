# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs versionator java-pkg-2

MY_PV=$(replace_all_version_separators '-')

DESCRIPTION="Java-based editor optimized for the OBO biological ontology file format"
HOMEPAGE="http://www.oboedit.org/"
SRC_URI="
	http://sourceforge.net/projects/geneontology/files/OBO-Edit%202%20%5BLatest%20versions%5D/OBO-Edit%20${PV}/${MY_PV}_unix_install4j.sh/download -> OBO-Edit_unix_install4j-${PV}.sh
	http://sourceforge.net/projects/geneontology/files/OBO-Edit%202%20%5BLatest%20versions%5D/OBO-Edit%20${PV}/ReleaseNotes-${PV}.txt"

LICENSE="OBO-Edit" # Artistic-like
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/rpm2targz"
RDEPEND="virtual/jre"

S="${WORKDIR}"

src_install(){
	dodir /opt/OBO-Edit2/.install4j

	sed \
		-e "s#\"\${D}\"#"${D}"#g" \
		"${FILESDIR}"/response.varfile \
		> "${D}"/opt/OBO-Edit2/.install4j/response.varfile || die "sed failed"

	sed \
		-e "s#/bin/java\" -Dinstall4j.jvmDir#/bin/java\" -Duser.home="${D}"/../temp -Dinstall4j.jvmDir#" \
		-i "${DISTDIR}"/OBO-Edit_unix_install4j-"${PV}".sh || die "failed to set userHome value"

	sh "${DISTDIR}"/OBO-Edit_unix_install4j-"${PV}".sh \
		-q -overwrite \
		--varfile="${D}"/opt/OBO-Edit2/.install4j/response.varfile \
		--destination="${D}"/opt/OBO-Edit2 \
		-dir "${D}"/opt/OBO-Edit2 \
		|| die "Failed to run the self-extracting ${DISTDIR}/OBO-Edit_unix_install4j-"${PV}".sh file"
	find . -name firstrun -delete || die

	esvn_clean

	insinto /opt/
	doins -r OBO-Edit2
	chmod 755 "${ED}"/opt/OBO-Edit2/* || die

	dodoc "${DISTDIR}"/ReleaseNotes-2.1.0.txt
}
