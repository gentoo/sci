# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Java-based editor optimized for the OBO biological ontology file format"
HOMEPAGE="http://www.oboedit.org/"
#SRC_URI="http://sourceforge.net/projects/geneontology/files/OBO-Edit%202%20%5BLatest%20versions%5D/oboedit2.1beta8/oboedit_2_1_8_unix_install4j.sh"
SRC_URI="http://sourceforge.net/projects/geneontology/files/OBO-Edit%202%20%5BLatest%20versions%5D/oboedit2.1beta8/oboedit_2_1_8_linux_install4j.rpm"

LICENSE="OBO-Edit" # Artistic-like
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/rpm2targz"
RDEPEND="${DEPEND}
	virtual/jre"

src_unpack() {
	cd "${WORKDIR}"
	rpm2targz "${DISTDIR}/oboedit_2_1_8_linux_install4j.rpm" || die
	tar -xzf "${WORKDIR}/oboedit_2_1_8_linux_install4j.tar.gz" || die
}

src_install(){
	# sh "${DISTDIR}"/oboedit_2_1_8_unix_install4j.sh -q -overwrite --var-file="${FILESDIR}"/response.varfile --destination="${D}"/opt/OBO-Edit2
	mkdir -p "${D}"/opt/ || die
	cp -rp opt/OBO-Edit2 "${D}"/opt/ || die
	find "${D}"/opt -name firstrun | xargs rm -f # drop a world writable file
	find "${D}"/opt -name .svn | xargs rm -rf
}
