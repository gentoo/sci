# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Crystallographic tools mainly for Rietveld analysis"
HOMEPAGE="http://www.ill.eu/sites/fullprof/index.html"
SRC_URI="http://www.ill.eu/sites/fullprof/downloads/FullProf_Suite_April2013_Lin.tgz"

LICENSE="freedist HPND"
# There is no clear license specified. But according to Docs/Readme_Fp_Suite.txt
# those two seem to be appropriate.
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+doc +examples +X"

RDEPEND="X? ( x11-libs/motif:0 )"
DEPEND=""
S="${WORKDIR}"

QA_PREBUILT="opt/.*"

src_install() {
	BASEDIR="/opt/fullprof"
	echo "FULLPROF=\"${BASEDIR}\"" > "${T}"/99fullprof
	doenvd "${T}"/99fullprof

	if ! use examples; then
		rm -r Examples || die
	fi

	if ! use doc; then
		rm -r Docs Html || die
	else
		# fix (html) documentation to actually work
		# as upstream is using inconsistent upper and lower case
		mv Docs docs || die
		cd docs || die
		for i in *.HTM; do
			mv "$i" "${i,,}" || die
		done
		mv "FullProf_Manual.pdf" "Fullprof_Manual.pdf" || die
		mv "Manual_FullProf_Studio.pdf" "Manual_Fullprof_Studio.pdf" || die
		mv "FullProf_News.htm" "Fullprof_News.htm" || die
		for i in FullProf_News_200?.htm; do
			mv "$i" "${i/FullProf/Fullprof}" || die
		done
		cd .. || die
	fi

	if ! use X; then
		rm -rf \
			tfp tfp.set winplotr-2006 check_group cryscal edpcr fp_studio \
			gbasireps gbond_str gdatared gfourier gfourier.hlp gxlens \
			powderpat resvis symmcal wfp2k winplotr.* \
			Fps_Icons || die
	fi

	dodir "${BASEDIR}"
	# make symlinks
	for i in * ; do
		[[ -x $i && ! -d $i ]] && dosym "../fullprof/${i}" /opt/bin/"${i##*/}"
	done
	mv "${S}"/* "${ED}/${BASEDIR}" || die
}
