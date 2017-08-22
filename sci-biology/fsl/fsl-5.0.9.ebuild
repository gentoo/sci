# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs prefix

DESCRIPTION="Analysis of functional, structural, and diffusion MRI brain imaging data"
HOMEPAGE="http://www.fmrib.ox.ac.uk/fsl"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}-sources.tar.gz"

LICENSE="FSL BSD-2 newmat"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
	dev-libs/boost
	media-gfx/graphviz
	media-libs/gd
	media-libs/glu
	media-libs/libpng:0=
	sys-libs/zlib
	"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	dev-lang/tcl:0=
	dev-lang/tk:0=
	"

S=${WORKDIR}/${PN}
UPSTREAM_FSLDIR="/usr/share/fsl"

PATCHES=(
	"${FILESDIR}/${PN}"-5.0.9-setup.patch
	"${FILESDIR}/${PN}"-5.0.9-headers.patch
	"${FILESDIR}/${PN}"-5.0.9-fsldir_redux.patch
)

src_prepare(){
	default
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

	sed -e "s:\${FSLDIR}/bin/::g" \
		-e "s:\$FSLDIR/bin/::g" \
		-i $(grep -rl "\${FSLDIR}/bin" src/*) \
		$(grep -rl "\${FSLDIR}/bin" etc/matlab/*) || die

	sed -e "s:\$FSLDIR/data:${EPREFIX}/usr/share/fsl/data:g" \
		-e "s:\${FSLDIR}/data:${EPREFIX}/usr/share/fsl/data:g" \
		-i $(grep -rl "\$FSLDIR/data" src/*) \
		$(grep -rl "\${FSLDIR}/data" src/*) || die

	sed -e "s:\$FSLDIR/doc:${EPREFIX}/usr/share/fsl/doc:g" \
		-e "s:\${FSLDIR}/doc:${EPREFIX}/usr/share/fsl/doc:g" \
		-i $(grep -rl "\$FSLDIR/doc" src/*) \
		$(grep -rl "\${FSLDIR}/doc" src/*) || die

	sed -e "s:/usr/share/fsl/doc:${EPREFIX}/usr/share/fsl/doc:g" \
		$(grep -rl "/usr/share/fsl/doc" src/*) || die

	sed -e "s:\$FSLDIR/etc:${EPREFIX}/etc:g" \
		-e "s:\${FSLDIR}/etc:${EPREFIX}/etc:g" \
		-i $(grep -rlI "\$FSLDIR/etc" *) \
		-i $(grep -rlI "\${FSLDIR}/etc" *) || die
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
		$(grep -l "\${FSLDIR}/tcl"  tcl/*) || die
	sed -i "s:\$FSLDIR/tcl:/usr/libexec/fsl:g" \
		$(grep -l "\$FSLDIR/tcl" tcl/*) || die

	dobin bin/*

	insinto /usr/share/${PN}
	doins -r data
	dodoc -r doc/. refdoc

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

	#the following is needed for FSL and depending programs to be able
	#to find its files, since FSL uses an uncommon installation path:
	#https://github.com/gentoo-science/sci/pull/612#r60289295
	dosym /etc ${UPSTREAM_FSLDIR}/etc
	dosym /usr/share/doc/${PF} ${UPSTREAM_FSLDIR}/doc
	dosym /usr/bin ${UPSTREAM_FSLDIR}/bin

	doenvd "$(prefixify_ro "${FILESDIR}"/99fsl)"
	mv "${ED}"/usr/bin/{,fsl_}cluster || die
}

pkg_postinst() {
	echo
	einfo "Please run the following commands if you"
	einfo "intend to use fsl from an existing shell:"
	einfo "env-update && source /etc/profile"
	echo
}
