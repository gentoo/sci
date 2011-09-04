# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils fortran-2 multilib toolchain-funcs

DESCRIPTION="The USF program suite"
HOMEPAGE="http://xray.bmc.uu.se/markh/usf"
SRC_URI="http://xray.bmc.uu.se/markh/usf/usf_distribution_kit.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="as-is"
IUSE=""

RDEPEND="
	sci-libs/ccp4-libs
	sci-libs/mmdb"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/usf_export

src_prepare() {
	local i j suffix
	epatch "${FILESDIR}"/${P}-build.patch
	ebegin "Fixing buildsystem"

	find ccp4libs* lib usf_osx_bin -delete
	for i in *; do
		if [[ -d ${i} && ${i} != gklib && ${i} != bin ]]; then
			pushd ${i} > /dev/null
				sed \
					-e 's:maxdim.incl:../maxdim.incl:g' \
					-e 's:../../maxdim.incl:../maxdim.incl:g' \
					-i * || die
				sed \
					-e "s:PROGRAMNAME:${i}:g" \
					-e "/^fc/s:^.*$:fc = ${FC} -DLINUX:g" \
					-e "/^opt/s:^.*$:opt = ${FFLAGS} -u -ffixed-line-length-132 -I..:g" \
					-e "/^link/s:^.*$:link = ${LDFLAGS}:g" \
					../Makefile_linux_template > Makefile || die

#			for suffix in subs gen; do
			for suffix in subs; do
				if [[ -f ${i}_${suffix}.f ]]; then
						sed "/^SUBS/s:$: ${i}_${suffix}.o:g " -i Makefile || die
				fi
			done
			popd > /dev/null
		fi
	done

	tc-export CC

	cp "${FILESDIR}"/Makefile_gklib gklib/Makefile || die
	cp "${FILESDIR}"/Makefile . || die

	eend
}

src_install() {
	dobin bin/*
	dolib.so gklib/*so*
}
