# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="An open-source environment for processing and displaying functional MRI data"
HOMEPAGE="http://afni.nimh.nih.gov/"
SRC_URI="https://github.com/afni/afni/archive/AFNI_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-AFNI_${PV}/src"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/libf2c
	dev-libs/expat
	media-libs/freeglut
	media-libs/glu
	media-libs/netpbm
	media-libs/qhull
	media-video/mpeg-tools
	sci-libs/gsl
	sys-devel/llvm:*
	virtual/jpeg:0
	x11-libs/libGLw
	x11-libs/libXft
	x11-libs/libXi
	x11-libs/libXpm
	x11-libs/motif
"

DEPEND="${RDEPEND}
	app-shells/tcsh
"

PATCHES=(
	# Drop python2.7 dependency
	"${FILESDIR}/${P}-python.patch"
)

BUILD="linux_fedora_19_64"
BIN_CONFLICTS=(qdelaunay whirlgif djpeg cjpeg qhull rbox count)

src_prepare() {
	find -type f -exec sed -i -e "s/-lXp //g" {} + || die
	cp other_builds/Makefile.${BUILD} Makefile || die "Could not copy Makefile"
	# Unbundle imcat
	sed -e "s/ imcat / /g" \
		-i Makefile.INCLUDE || die "Could not edit includes files."
	sed -e "s~CC     = /usr/bin/gcc -O2 -m64~CC     = $(tc-getCC) \$(CFLAGS)~" \
		-e "s~CCMIN  = /usr/bin/gcc -m64~CCMIN  = $(tc-getCC) \$(CFLAGS)~" \
		-e "s~LD     = /usr/bin/gcc~LD     = $(tc-getCC)~" \
		-e "s~AR     = /usr/bin/ar~AR     = $(tc-getAR)~" \
		-e "s~RANLIB = /usr/bin/ranlib~RANLIB = $(tc-getRANLIB)~" \
		-i Makefile || die "Could not edit Makefile"
		# they provide somewhat problematic makefiles :(
	sed -e "s~ifeq (\$(CC),gcc)~ifeq (1,1)~"\
		-i SUMA/SUMA_Makefile || die "Could not edit SUMA/SUMA_Makefile"
		# upstream checks if $CC is EXACTLY gcc, else sets variables for Mac
	find "${S}" -iname "*Makefile*" | xargs sed -e "s~/usr/~${EPREFIX}/usr/~g;" -i || die
	default
}

src_compile() {
	emake -j1 all plugins suma_exec
}

src_install() {
	emake INSTALLDIR="${ED}/usr/bin" install install_plugins
	emake INSTALLDIR="${ED}/usr/$(get_libdir)" install_lib
	for CONFLICT in ${BIN_CONFLICTS[@]}; do
		rm "${ED}/usr/bin/${CONFLICT}" || die
	done
}
