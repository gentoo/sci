# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

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

IUSE_OPENLOOPS_PROCESSES="
	openloops_processes_eella-ew
	openloops_processes_ppajj
	openloops_processes_pphllj-ew
	openloops_processes_ppjj
	openloops_processes_ppjj-ew
	openloops_processes_ppjjj
	openloops_processes_pplla
	openloops_processes_pplla-ew
	openloops_processes_ppllaj
	openloops_processes_ppllajj
	openloops_processes_ppllj
	openloops_processes_ppllj-ew
	openloops_processes_pplljj
	openloops_processes_pplnj-ckm
	openloops_processes_pplnjj-ckm
"

SRC_URI="
	openloops_processes_eella-ew?   ( ${COMMON_URI}/eella_ew/-/archive/a4b41a31/eella_ew-a4b41a31.tar.bz2   )
	openloops_processes_ppajj?      ( ${COMMON_URI}/ppajj/-/archive/93a6e3f7/ppajj-93a6e3f7.tar.bz2         )
	openloops_processes_pphllj-ew?  ( ${COMMON_URI}/pphllj_ew/-/archive/93a6e3f7/pphllj_ew-93a6e3f7.tar.bz2 )
	openloops_processes_ppjj?       ( ${COMMON_URI}/ppjj/-/archive/d3d5302/ppjj-d3d5302.tar.bz2             )
	openloops_processes_ppjj-ew?    ( ${COMMON_URI}/ppjj_ew/-/archive/d3d5302/ppjj_ew-d3d5302.tar.bz2       )
	openloops_processes_ppjjj?      ( ${COMMON_URI}/ppjjj/-/archive/93a6e3f7/ppjjj-93a6e3f7.tar.bz2         )
	openloops_processes_pplla?      ( ${COMMON_URI}/pplla/-/archive/a3a36918/pplla-a3a36918.tar.bz2         )
	openloops_processes_pplla-ew?   ( ${COMMON_URI}/pplla_ew/-/archive/0a26af9a/pplla_ew-0a26af9a.tar.bz2   )
	openloops_processes_ppllaj?     ( ${COMMON_URI}/ppllaj/-/archive/c77e3a3/ppllaj-c77e3a3.tar.bz2         )
	openloops_processes_ppllajj?    ( ${COMMON_URI}/ppllajj/-/archive/4d8743c/ppllajj-4d8743c.tar.bz2       )
	openloops_processes_ppllj?      ( ${COMMON_URI}/ppllj/-/archive/a4b41a31/ppllj-a4b41a31.tar.bz2         )
	openloops_processes_ppllj-ew?   ( ${COMMON_URI}/ppllj_ew/-/archive/4d20a80d/ppllj_ew-4d20a80d.tar.bz2   )
	openloops_processes_pplljj?     ( ${COMMON_URI}/pplljj/-/archive/93a6e3f7/pplljj-93a6e3f7.tar.bz2       )
	openloops_processes_pplnj-ckm?  ( ${COMMON_URI}/pplnj_ckm/-/archive/4d8743c/pplnj_ckm-4d8743c.tar.bz2   )
	openloops_processes_pplnjj-ckm? ( ${COMMON_URI}/pplnjj_ckm/-/archive/d3d5302/pplnjj_ckm-d3d5302.tar.bz2 )
"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/openloops/OpenLoops"
	EGIT_BRANCH="master"
else
	SRC_URI+="https://gitlab.com/openloops/OpenLoops/-/archive/${MY_P}/${MY_PN}-${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_PN}-${MY_P}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="+collier +cuttools +extra ${IUSE_OPENLOOPS_PROCESSES}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	sci-physics/qcdloop
	sci-physics/oneloop[dpkind,qpkind16,-qpkind,-cppintf]
	collier? ( sci-physics/collier[-static-libs] )
	cuttools? ( sci-physics/cuttools[dummy] )
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

src_unpack() {
	# Needed to unpack the processes
	default

	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	default
	mv openloops.cfg.tmpl openloops.cfg || die
	sed -i "s|\\\$BASEDIR/scons -Q|scons -Q -C /opt/${MY_P}/|g" openloops || die
	if use extra ; then
		sed -i "s|#compile_extra.*|compile_extra = 1|" openloops.cfg || die
	fi

	cat <<-EOF >> openloops.cfg || die
	compile_libraries = rambo trred
	link_libraries = $(usev collier) $(usev cuttools) rambo trred
	ccflags = ${CFLAGS}
	cxxflags = ${CXXFLAGS}
	f_path = ${ESYSROOT}/usr/include/
	f_flags = ${FFLAGS} -I${ESYSROOT}/usr/include/cuttools -lcollier
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
	for OLPROC in ${IUSE_OPENLOOPS_PROCESSES};
	do
		if use ${OLPROC}; then
			MY_OLPROC=${OLPROC//-/_}
			MY_OLPROC=${MY_OLPROC#openloops_processes_}
			# move downloaded files to src
			mkdir -p "${S}/process_src/${MY_OLPROC}" || die
			mv "${WORKDIR}/${MY_OLPROC}-"*/* "${S}/process_src/${MY_OLPROC}" || die
			# compile it
			escons auto=${MY_OLPROC} generator=0
		fi
	done

	# insert these later since we are done with compiling in ${S} now
	cat <<-EOF >> openloops.cfg || die
	process_src_dir = ${EPREFIX}/opt/${MY_P}/process_src/
	process_obj_dir = ${EPREFIX}/opt/${MY_P}/process_obj/
	process_lib_dir = ${EPREFIX}/opt/${MY_P}/proclib/
	EOF
}

src_install() {
	dosym ../opt/${MY_P} /opt/OpenLoops2
	dobin openloops
	cd include || die
	doheader openloops.h

	newenvd - 99openloops2 <<- _EOF_
		OpenLoopsPath=${EPREFIX}/opt/OpenLoops2
	_EOF_

	# Also install so.version links
	cd ../lib || die
	dolib.so libolcommon.so* libopenloops.so* librambo.so* libtrred.so*

	cd .. || die
	# install processes
	if [ -d "./proclib" ]; then
		dodir "/opt/${MY_P}/proclib"
		mv proclib/* "${ED}/opt/${MY_P}/proclib/" || die
	fi

	cd ./lib_src/olcommon/mod || die
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
	elog "They are installed in ${EPREFIX}/opt/${MY_P}/proclib/."
}
