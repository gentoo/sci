# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base eutils toolchain-funcs versionator

MY_PV="$(delete_all_version_separators ${PV})"

DESCRIPTION="A new GUI for the Mosflm crystallographic data processing tool"
HOMEPAGE="http://www.mrc-lmb.cam.ac.uk/harry/imosflm"
SRC_URI="${HOMEPAGE}/ver${MY_PV}/downloads/${P}.zip"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=dev-tcltk/itcl-3.3
	>=dev-tcltk/itk-3.3
	>=dev-tcltk/iwidgets-4
	>=dev-tcltk/tkimg-1.3
	>=dev-tcltk/tdom-0.8
	dev-tcltk/tablelist
	dev-tcltk/anigif
	dev-tcltk/combobox
	>=dev-tcltk/tktreectrl-2.1
	>=sci-chemistry/mosflm-7.0.4
	dev-lang/tcl"
DEPEND=""

S="${WORKDIR}"/${PN}

PATCHES=(
	"${FILESDIR}"/${PV}-tk.patch
	)

src_compile() {
	cd c

	objs="tkImageLoadDLL.o tkImageLoad.o"
	libs="-ltclstub -ltkstub"
	config="-fPIC -DUSE_TCL_STUBS -DTK_USE_STUBS"
	ldextra="-shared"

	for file in ${objs}; do
		einfo "$(tc-getCC) -c ${CFLAGS} ${config} ${file/.o/.c} -o ${file}"
		$(tc-getCC) -c ${CFLAGS} ${config} ${file/.o/.c} -o ${file}
	done

	einfo "$(tc-getCC) ${LDFLAGS} ${ldextra} ${objs} -o tkImageLoad.so ${libs}"
	$(tc-getCC) ${LDFLAGS} ${ldextra} ${objs} -o tkImageLoad.so ${libs}
}

src_install(){
	rm -rf lib/{*.so,anigif,combobox}

	insinto /usr/$(get_libdir)/${PN}
	doins -r "${S}"/{src,bitmaps,lib}
	fperms 775 /usr/$(get_libdir)/${PN}/src/imosflm

	dolib.so c/tkImageLoad.so

	make_wrapper imosflm /usr/$(get_libdir)/${PN}/src/imosflm
}
