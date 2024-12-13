# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit fortran-2 python-single-r1 scons-utils toolchain-funcs

MY_PN=OpenLoops
MY_P=${MY_PN}-${PV}

DESCRIPTION="Evaluation of tree and one-loop matrix elements for any Standard Model."
HOMEPAGE="https://openloops.hepforge.org/index.html"
#SRC_URI="https://openloops.hepforge.org/downloads?f=${MY_P}.tar.gz -> ${MY_P}.tar.gz"
#S="${WORKDIR}/${MY_P}"
# since the files are not publicly versioned we mirror them from
# https://www.physik.uzh.ch/data/openloops/repositories/public/processes/2
COMMON_URI="https://gitlab.com/openloopsmirror/"

SRC_URI="
	https://gitlab.com/openloops/OpenLoops/-/archive/${MY_P}/${MY_PN}-${MY_P}.tar.bz2
	ppllj? ( ${COMMON_URI}/ppllj/-/archive/a3a36918/ppllj-a3a36918.tar.bz2 )
	pplljj? ( ${COMMON_URI}/pplljj/-/archive/93a6e3f7/pplljj-93a6e3f7.tar.bz2 )
	pplnj-ckm? ( ${COMMON_URI}/pplnj_ckm/-/archive/4d8743c/pplnj_ckm-4d8743c.tar.bz2 )
	pplnjj-ckm? ( ${COMMON_URI}/pplnjj_ckm/-/archive/d3d5302/pplnjj_ckm-d3d5302.tar.bz2 )
"
S="${WORKDIR}/${MY_PN}-${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+collier +cuttools +extra ppllj pplljj pplnj-ckm pplnjj-ckm"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	sci-physics/qcdloop
	sci-physics/oneloop[dpkind,qpkind16,-qpkind,-cppintf]
	collier? ( sci-physics/collier[-static-libs] )
	cuttools? ( sci-physics/cuttools[dummy] )
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.1.2-ldflags.patch"
)

src_prepare() {
	default
	mv openloops.cfg.tmpl openloops.cfg || die
	sed -i "s|\\\$BASEDIR/scons -Q|scons -Q -C /opt/${MY_P}/|g" openloops || die
	if use extra ; then
		sed -i "s|#compile_extra.*|compile_extra = 1|" openloops.cfg || die
	fi

	cat <<-EOF >> openloops.cfg || die
	compile_libraries = rambo trred
	link_libraries = $(usev collier) $(usev cuttools)
	ccflags = ${CFLAGS}
	cxxflags = ${CXXFLAGS}
	f_flags = ${FFLAGS} -I${ESYSROOT}/usr/include/ -I${ESYSROOT}/usr/include/cuttools -lcollier
	link_flags = ${LDFLAGS} -I${ESYSROOT}/usr/include/ -I${ESYSROOT}/usr/include/cuttools -lcollier
	cc = $(tc-getCC)
	cxx = $(tc-getCXX)
	fortran_compiler = $(tc-getFC)

	release = $PV
	import_env = @all
	EOF

	# fix rename for py3.12
	sed -i 's/SafeConfigParser/ConfigParser/g' pyol/tools/OLBaseConfig.py || die
	# wipe local scons
	rm -r scons-local || die
	rm scons || die
}

src_compile() {
	escons --cache-disable
	for OLPROC in ppllj pplljj pplnj_ckm pplnjj_ckm;  do
		if use ${OLPROC//_/-}; then
			# move downloaded files to src
			mkdir -p "${S}/process_src/${OLPROC}" || die
			mv "${WORKDIR}/${OLPROC}-"*/* "${S}/process_src/${OLPROC}" || die
			# compile it
			escons auto=${OLPROC} generator=0
		fi
	done

	# insert these later since we are done with compiling in ${S} now
	cat <<-EOF >> openloops.cfg || die
	process_src_dir = ${EPREFIX}/opt/${MY_P}/process_src/
	process_obj_dir = ${EPREFIX}/opt/${MY_P}/process_obj/
	process_lib_dir = ${EPREFIX}/usr/$(get_libdir)/
	EOF
}

src_install() {
	dosym ../opt/${MY_P} /opt/OpenLoops2
	dobin openloops
	cd include || die
	doheader openloops.h

	# Also install so.version links
	cd ../lib || die
	dolib.so libolcommon.so* libopenloops.so* librambo.so* libtrred.so*

	# install processes
	if [ -d "../proclib" ]; then
		cd ../proclib || die
		dolib.so *.so
		# also install the process info files
		insinto /usr/$(get_libdir)/
		doins *.info
	fi

	cd ../lib_src/olcommon/mod || die
	doheader *.mod
	cd ../../openloops/mod || die
	doheader *.mod
	cd ../../rambo/mod || die
	doheader *.mod
	cd ../../trred/mod || die
	doheader *.mod

	cd "${S}" || die "Failed to cd into ${S}"
	insinto /opt/${MY_P}
	doins openloops.cfg SConstruct
	doins -r pyol

	# no need to also install the source code
	#doins -r process_src
}

pkg_postinst() {
	elog "Install processes with openloops libinstall."
	elog "They are installed in ${EPREFIX}/usr/$(get_libdir)/."
}
