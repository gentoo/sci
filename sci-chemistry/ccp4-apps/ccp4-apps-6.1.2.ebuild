# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran eutils gnuconfig toolchain-funcs autotools

FORTRAN="g77 gfortran ifc"

MY_P="${PN/-apps}-${PV}"

SRC="ftp://ftp.ccp4.ac.uk/ccp4"

#UPDATE="04_03_09"
#PATCHDATE="090511"

PATCH_TOT="0"
# Here's a little scriptlet to generate this list from the provided
# index.patches file
#
# i=1; while read -a line; do [[ ${line//#} != ${line} ]] && continue;
# echo "PATCH${i}=( ${line[1]}"; echo "${line[0]} )"; (( i++ )); done <
# index.patches
#PATCH1=( src/topp_
#topp.f-r1.16.2.5-r1.16.2.6.diff )
#PATCH2=( .
#configure-r1.372.2.18-r1.372.2.19.diff )

DESCRIPTION="Protein X-ray crystallography toolkit"
HOMEPAGE="http://www.ccp4.ac.uk/"
RESTRICT="mirror"
SRC_URI="${SRC}/${PV}/${MY_P}-core-src.tar.gz"
# patch tarball from upstream
	[[ -n ${UPDATE} ]] && SRC_URI="${SRC_URI} ${SRC}/${PV}/updates/${P}-src-patch-${UPDATE}.tar.gz"
# patches created by us
	[[ -n ${PATCHDATE} ]] && SRC_URI="${SRC_URI} http://dev.gentooexperimental.org/~jlec/science-dist/${PV}-${PATCHDATE}-updates.patch.bz2"

for i in $(seq $PATCH_TOT); do
	NAME="PATCH${i}[1]"
	SRC_URI="${SRC_URI}
		${SRC}/${PV}/patches/${!NAME}"
done

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X examples"

# app-office/sc overlaps sc binary and man page
# We can't rename ours since the automated ccp4i interface expects it there,
# as do many scripts. app-office/sc can't rename its because that's the name
# of the package.
X11DEPS="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXaw
	x11-libs/libxdl_view
	x11-libs/libjwc_c
	x11-libs/libjwc_f"

TKDEPS=">=dev-lang/tk-8.3
	>=dev-tcltk/blt-2.4
	dev-tcltk/iwidgets
	>=dev-tcltk/tdom-0.8
	dev-tcltk/tkimg
	dev-tcltk/tktreectrl
	dev-tcltk/itcl
	dev-tcltk/itk"

SCILIBS="sci-libs/ccp4-libs
	virtual/lapack
	virtual/blas
	=sci-libs/fftw-2*
	sci-libs/clipper
	sci-libs/balbes-db"

SCIAPPS="sci-chemistry/pdb-extract
	sci-chemistry/rasmol"


RDEPEND="X? ( ${X11DEPS} )
	${TKDEPS}
	${SCILIBS}
	${SCIAPPS}
	app-shells/tcsh
	dev-python/pyxml
	dev-libs/libxml2
	dev-libs/boehm-gc
	!app-office/sc
	!<sci-chemistry/ccp4-6.1.2"
DEPEND="${RDEPEND}
	=sys-devel/automake-1.6*
	X? (
		x11-misc/imake
		x11-proto/inputproto
		x11-proto/xextproto
	)"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	einfo "Applying upstream patches ..."
	for patch in $(seq $PATCH_TOT); do
		base="PATCH${patch}"
		dir=$(eval echo \${${base}[0]})
		p=$(eval echo \${${base}[1]})
		pushd "${dir}" >& /dev/null
		ccp_patch ${DISTDIR}/"${p}"
		popd >& /dev/null
	done
	einfo "Done."
	echo

	[[ -n ${PATCHDATE} ]] && epatch "${WORKDIR}"/${PV}-${PATCHDATE}-updates.patch

	einfo "Applying Gentoo patches ..."

	# it tries to create libdir, bindir etc on live system in configure
	ccp_patch "${FILESDIR}"/${PV}-dont-make-dirs-in-configure.patch

	# We already have sci-chemistry/rasmol
	# Also remember to create the bindir.
	ccp_patch "${FILESDIR}"/${PV}-dont-build-double-and-make-bindir.patch

	# libraries come from sci-libs/ccp4-libs
	ccp_patch "${FILESDIR}"/${PV}-dont-build-libs.patch

	# coreutils installs a binary called truncate
	ccp_patch "${FILESDIR}"/${PV}-rename-truncate.patch
	mv ./doc/truncate.doc ./doc/ftruncate.doc || die
	mv ./html/truncate.html ./html/ftruncate.html || die

	# conflicts with media-libs/raptor
	ccp_patch "${FILESDIR}"/${PV}-rename-rapper.patch
	mv ./doc/rapper.doc ./doc/rappermc.doc || die
	mv ./html/rapper.html ./html/rappermc.html || die

	# molref is provided as binary and dynamically linked against icc
	ccp_patch "${FILESDIR}"/${PV}-dont-build-molref.patch

	# no xia
	ccp_patch "${FILESDIR}"/${PV}-dont-build-xia.patch

	# We build scala ourself
	ccp_patch "${FILESDIR}"/${PV}-dont-build-scala.patch

	# We build scala ourself
	ccp_patch "${FILESDIR}"/${PV}-dont-build-imosflm.patch

	# gcc-4.3.3
	ccp_patch "${FILESDIR}"/${PV}-gcc4.4.patch

	einfo "Done." # done applying Gentoo patches
	echo

	# Don't build refmac binaries available from the standalone version
	sed -i -e "/^REFMACTARGETS/s:refmac5 libcheck makecif molrep::g" configure

	# Rapper bundles libxml2 and boehm-gc. Don't build, use or install those.
	pushd src/rapper 2>/dev/null
	sed -i \
		-e '/^AC_CONFIG_SUBDIRS(\[gc7.0 libxml2\])/d' \
		configure.ac
	sed -i \
		-e '/^SUBDIRS/s:libxml2 gc7.0::g' \
		Makefile.am
	sed -i \
		-e '/^rappermc_LDADD/s:../gc7.0/libgc.la ../libxml2/libxml2.la:-lgc -lxml2:g' \
		LOOP/Makefile.am
	sed -i \
		-e '/^INCLUDES/s:-I../gc7.0/include -I../libxml2/include:-I/usr/include/gc -I/usr/include/libxml2:g' \
		LOOP/Makefile.am
	eautoreconf
	popd 2>/dev/null

	gnuconfig_update
}

src_compile() {
	# Build system is broken if we set LDFLAGS
	unset LDFLAGS

	# GENTOO_OSNAME can be one of:
	# irix irix64 sunos sunos64 aix hpux osf1 linux freebsd
	# linux_compaq_compilers linux_intel_compilers generic Darwin
	# ia64_linux_intel Darwin_ibm_compilers linux_ibm_compilers
	if [[ "${FORTRANC}" = "ifc" ]]; then
		if use ia64; then
			GENTOO_OSNAME="ia64_linux_intel"
		else
			# Should be valid for x86, maybe amd64
			GENTOO_OSNAME="linux_intel_compilers"
		fi
	else
		# Should be valid for x86 and amd64, at least
		GENTOO_OSNAME="linux"
	fi

	# Sets up env
	ln -s \
		ccp4.setup-bash \
		"${S}"/include/ccp4.setup

	# We agree to the license by emerging this, set in LICENSE
	sed -i \
		-e "s~^\(^agreed=\).*~\1yes~g" \
		"${S}"/configure

	# Fix up variables -- need to reset CCP4_MASTER at install-time
	sed -i \
		-e "s~^\(setenv CCP4_MASTER.*\)/.*~\1${WORKDIR}~g" \
		-e "s~^\(setenv CCP4I_TCLTK.*\)/usr/local/bin~\1/usr/bin~g" \
		"${S}"/include/ccp4.setup*

	# Set up variables for build
	source "${S}"/include/ccp4.setup

	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export COPTIM=${CFLAGS}
	export CXXOPTIM=${CXXFLAGS}
	# Default to -O2 if FFLAGS is unset
	export FC=${FORTRANC}
	export FOPTIM=${FFLAGS:- -O2}
	export BINSORT_SCR="${T}"

	# Can't use econf, configure rejects unknown options like --prefix
	./configure \
		$(use_enable X x) \
		--with-shared-libs \
		--with-fftw=/usr \
		--with-warnings \
		--disable-pdb_extract \
		--disable-cctbx \
		--disable-phaser \
		--disable-clipper \
		--disable-mosflm \
		--disable-mrbump \
		--tmpdir="${TMPDIR}" \
		${GENTOO_OSNAME} || die "econf failed"

	# fsplit is required for the programs
	pushd lib/src 2>/dev/null
	emake fsplit -j1 || die
	popd 2>/dev/null

	# We do this manually, since disabling the clipper libraries also
	# disables the clipper programs
	pushd src/clipper_progs 2>/dev/null
	econf \
		--prefix="${S}" \
		--with-ccp4="${S}" \
		--with-clipper=/usr \
		--with-fftw=/usr \
		--with-mmdb=/usr \
		CXX=$(tc-getCXX) \
		|| die
	emake || die
	popd 2>/dev/null

	emake -j1 || die "emake failed"
}

src_install() {
	# Set up variables for build
	source "${S}"/include/ccp4.setup

#	make install || die "install failed"

	# if we don't make this, a ton of programs fail to install
	mkdir "${S}"/bin || die

	# We do this manually, since disabling the clipper libraries also
	# disables the clipper programs
	pushd "${S}"/src/clipper_progs 2>/dev/null
	emake install || die
	popd 2>/dev/null

	einstall || die "install failed"

	# Fix env
	sed -i \
		-e "s~^\(setenv CCP4_MASTER.*\)${WORKDIR}~\1/usr~g" \
		-e "s~^\(setenv CCP4.*\$CCP4_MASTER\).*~\1~g" \
		-e "s~^\(setenv CCP4I_TOP\).*~\1 \$CCP4/$(get_libdir)/ccp4/ccp4i~g" \
		-e "s~^\(setenv DBCCP4I_TOP\).*~\1 \$CCP4/share/ccp4/dbccp4i~g" \
		-e "s~^\(.*setenv CINCL.*\$CCP4\).*~\1/share/ccp4/include~g" \
		-e "s~^\(.*setenv CLIBD .*\$CCP4\).*~\1/share/ccp4/data~g" \
		-e "s~^\(.*setenv CLIBD_MON .*\)\$CCP4.*~\1\$CCP4/share/ccp4/data/monomers/~g" \
		-e "s~^\(.*setenv MOLREPLIB .*\)\$CCP4.*~\1\$CCP4/share/ccp4/data/monomers/~g" \
		-e "s~^\(.*setenv PYTHONPATH .*\)\$CCP4.*~\1\$CCP4/share/ccp4/python~g" \
		-e "s~^\(.*setenv CCP4_BROWSER.*\).*~\1 firefox~g" \
		"${S}"/include/ccp4.setup* || die

	# Don't check for updates on every sourcing of /etc/profile
	sed -i \
		-e "s:\(eval python.*\):#\1:g"
		"${S}"/include/ccp4.setup* || die

	# Bins
	dobin "${S}"/bin/* || die

	# Libs
	for file in "${S}"/lib/*; do
		if [[ -d ${file} ]]; then
			continue
		elif [[ -x ${file} ]]; then
			dolib.so ${file} || die
		else
			insinto /usr/$(get_libdir)
			doins ${file} || die
		fi
	done

	# Setup scripts
	insinto /etc/profile.d
#	newins "${S}"/include/ccp4.setup-bash ccp4.setup.bash || die
	newins "${S}"/include/ccp4.setup-csh ccp4.setup.csh || die
#	newins "${S}"/include/ccp4.setup-zsh ccp4.setup.zsh || die
	newins "${S}"/include/ccp4.setup-sh ccp4.setup.sh || die
	rm -f "${S}"/include/ccp4.setup*

	# Environment files, setup scripts, etc.
	insinto /usr/share/ccp4/include
	doins "${S}"/include/* || die

	# smartie -- log parsing
	insinto /usr/share/ccp4
	doins -r "${S}"/share/smartie || die

	# Install docs and examples

	doman "${S}"/man/cat1/*

	mv "${S}"/manual/README "${S}"/manual/README-manual
	dodoc "${S}"/manual/*

	dodoc "${S}"/README "${S}"/CHANGES

	dodoc "${S}"/doc/*
	rm "${D}"/usr/share/doc/${PF}/GNUmakefile.*
	rm "${D}"/usr/share/doc/${PF}/COPYING.*

	dohtml -r "${S}"/html/*
	dodoc "${S}"/examples/README

	# Fix wrongly installed HTML pages from clipper
	dohtml "${D}"/usr/html/*
	rm -rf "${D}"/usr/html

	if use examples; then
		for i in data rnase toxd; do
			docinto examples/${i}
			dodoc "${S}"/examples/${i}/*
		done

		docinto examples/tutorial
		dohtml -r "${S}"/examples/tutorial/html examples/tutorial/tut.css
		for i in data results; do
			docinto examples/tutorial/${i}
			dodoc "${S}"/examples/tutorial/${i}/*
		done

		for i in non-runnable runnable; do
			docinto examples/unix/${i}
			dodoc "${S}"/examples/unix/${i}/*
		done
	fi
	# Needed for ccp4i docs to work
	dosym ../../share/doc/${PF}/examples /usr/$(get_libdir)/ccp4/examples
	dosym ../../share/doc/${PF}/html /usr/$(get_libdir)/ccp4/html

	# Fix overlaps with other packages
	rm -f "${D}"/usr/share/man/man1/rasmol.1* "${D}"/usr/lib/font84.dat || die
}

pkg_postinst() {
	einfo "The Web browser defaults to firefox. Change CCP4_BROWSER"
	einfo "in /etc/profile.d/ccp4.setup* to modify this."
}


# Epatch wrapper for bulk patching
ccp_patch() {
	EPATCH_SINGLE_MSG="  ${1##*/} ..." epatch ${1}
}

