# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Crystallographic tools mainly for Rietveld analysis"
HOMEPAGE="https://www.ill.eu/sites/fullprof/index.html"
# Does not fetch correctly with wget, we get the index.html file instead
# their website seems to explicitly not want us to do this so we
# add RESTRICT="fetch"
#SRC_URI="https://www.ill.eu/sites/fullprof/downloads/FullProf_Suite_September2020_Linux64.tgz"
SRC_URI="FullProf_Suite_September2020_Linux64.tgz"
RESTRICT="fetch"

LICENSE="freedist HPND"
# There is no clear license specified. But according to Docs/Readme_Fp_Suite.txt
# those two seem to be appropriate.
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="x11-libs/motif"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

QA_PREBUILT="opt/.*"

pkg_nofetch() {
	einfo "Please access https://www.ill.eu/sites/fullprof/downloads/${SRC_URI} using a browser"
	einfo "and place the tgz file in your DISTDIR directory."
}

src_install() {
	BASEDIR="/opt/fullprof"
	echo "FULLPROF=\"${BASEDIR}\"" > "${T}"/99fullprof
	doenvd "${T}"/99fullprof

	dodir "${BASEDIR}"
	# make symlinks
	for i in * ; do
		[[ -x $i && ! -d $i ]] && dosym "../fullprof/${i}" /opt/bin/"${i##*/}"
	done
	mv "${S}"/* "${ED}/${BASEDIR}" || die
}
