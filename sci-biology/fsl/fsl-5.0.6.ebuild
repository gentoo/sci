# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs prefix

DESCRIPTION="Analysis of functional, structural, and diffusion MRI brain imaging data"
HOMEPAGE="http://www.fmrib.ox.ac.uk/fsl"
SRC_URI="http://fsl.fmrib.ox.ac.uk/fsldownloads/${P}-sources.tar.gz"

LICENSE="FSL newmat"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="media-libs/glu
	media-libs/libpng
	media-libs/gd
	sys-libs/zlib
	dev-libs/boost
	media-gfx/graphviz
	"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	dev-lang/tcl
	dev-lang/tk
	"

S=${WORKDIR}/${PN}

src_prepare(){
	epatch "${FILESDIR}/${PN}"-5.0.4-setup.patch
	epatch "${FILESDIR}/${PN}"-5.0.4-headers.patch
	epatch "${FILESDIR}/${PN}"-5.0.6-fsldir_redux.patch

	sed -i \
		-e "s:@@GENTOO_RANLIB@@:$(tc-getRANLIB):" \
		-e "s:@@GENTOO_CC@@:$(tc-getCC):" \
		-e "s:@@GENTOO_CXX@@:$(tc-getCXX):" \
		config/generic/systemvars.mk || die

	eprefixify $(grep -rl GENTOO_PORTAGE_EPREFIX src/*) \
		etc/js/label-div.html

	makefilelist=$(find src/ -name Makefile)

	sed -i \
		-e "s:-I\${INC_BOOST}::" \
		-e "s:-I\${INC_ZLIB}::" \
		-e "s:-I\${INC_GD}::" \
		-e "s:-I\${INC_PNG}::" \
		-e "s:-L\${LIB_GD}::" \
		-e "s:-L\${LIB_PNG}::" \
		-e "s:-L\${LIB_ZLIB}::" \
		${makefilelist} || die

	sed -i "s:\${FSLDIR}/bin/::g" \
		$(grep -rl "\${FSLDIR}/bin" src/*) \
		$(grep -rl "\${FSLDIR}/bin" etc/matlab/*)
	sed -i "s:\$FSLDIR/bin/::g" \
		$(grep -rl "\$FSLDIR/bin" src/*) \
		$(grep -rl "\$FSLDIR/bin" etc/matlab/*)

	sed -i "s:\$FSLDIR/data:${EPREFIX}/usr/share/fsl/data:g" \
		$(grep -rl "\$FSLDIR/data" src/*)

	sed -i "s:\${FSLDIR}/data:${EPREFIX}/usr/share/fsl/data:g" \
		$(grep -rl "\${FSLDIR}/data" src/*)

	sed -i "s:\$FSLDIR/etc:${EPREFIX}/etc:g" \
		$(grep -rl "\$FSLDIR/etc" src/*)

	sed -i "s:\${FSLDIR}/etc:${EPREFIX}/etc:g" \
		$(grep -rl "\${FSLDIR}/etc" src/*)

	sed -i "s:\$FSLDIR/doc:${EPREFIX}/usr/share/fsl/doc:g" \
		$(grep -rl "\$FSLDIR/doc" src/*)

	sed -i "s:\${FSLDIR}/doc:${EPREFIX}/usr/share/fsl/doc:g" \
		$(grep -rl "\${FSLDIR}/doc" src/*)

	sed -i "s:\'\${FSLDIR}\'/doc:${EPREFIX}/usr/share/fsl/doc:g" \
		$(grep -rl "\'\${FSLDIR}\'/doc" src/*)

	sed -i -e "s:\$FSLDIR/etc:/etc:g" `grep -rlI \$FSLDIR/etc *`
}

src_compile() {
	export FSLDIR=${WORKDIR}/${PN}
	export FSLCONDIR=${WORKDIR}/${PN}/config
	export FSLMACHTYPE=generic

	export USERLDFLAGS="${LDFLAGS}"
	export USERCFLAGS="${CFLAGS}"
	export USERCXXFLAGS="${CXXFLAGS}"

	./build || die
}

src_install() {
	sed -i "s:\${FSLDIR}/tcl:/usr/libexec/fsl:g" \
		$(grep -lI "\${FSLDIR}/tcl" bin/*) \
		$(grep -l "\${FSLDIR}/tcl"  tcl/*)
	sed -i "s:\$FSLDIR/tcl:/usr/libexec/fsl:g" \
		$(grep -l "\$FSLDIR/tcl" tcl/*)

	exeinto /usr/bin
	doexe bin/*

	insinto /usr/share/${PN}
	doins -r doc data refdoc

	insinto /usr/libexec/fsl
	doins -r tcl/*

	insinto /etc/fslconf
	doins etc/fslconf/fsl.sh

	insinto /etc
	doins etc/fslversion
	doins -r etc/default_flobs.flobs etc/flirtsch etc/js etc/luts
	#if use matlab; then
	#	doins etc/matlab
	#fi

	doenvd "${FILESDIR}"/99fsl
	rm "${D}"/usr/bin/cluster
}
