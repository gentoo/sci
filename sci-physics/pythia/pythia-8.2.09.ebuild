# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/pythia/pythia-8.1.86.ebuild,v 1.3 2015/05/27 11:19:04 ago Exp $

EAPI=5

inherit eutils versionator toolchain-funcs multilib

MV=$(get_major_version)
MY_P=${PN}$(replace_all_version_separators "" ${PV})

DESCRIPTION="Lund Monte Carlo high-energy physics event generator"
HOMEPAGE="http://pythia8.hepforge.org/"
SRC_URI="http://home.thep.lu.se/~torbjorn/${PN}${MV}/${MY_P}.tgz"

SLOT="8"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="doc examples gzip +hepmc fastjet lhapdf root test"

RDEPEND="
	fastjet? ( >=sci-physics/fastjet-3 )
	gzip? ( sys-libs/zlib )
	hepmc? ( sci-physics/hepmc:0= )
	lhapdf? ( >=sci-physics/lhapdf-6:= )
"
# ROOT is used only when building related tests
DEPEND="${RDEPEND}
	test? ( root? ( sci-physics/root:= ) )
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	PYTHIADIR="${EPREFIX}/usr/share/pythia8"
	# set datadir for xmldor in include file
	sed -i \
		-e "s:../share/Pythia8/xmldoc:${PYTHIADIR}/xmldoc:" \
		include/Pythia8/Pythia.h || die
	# respect libdir, prefix, flags
	sed -i \
		-e "s:/lib:/$(get_libdir):g" \
		-e "s:/usr:${EPREFIX}/usr:g" \
		-e "s:-O2:${CXXFLAGS}:g" \
		-e "s:Cint:Core:g" \
		configure || die
	# we use lhapdf6 instead of lhapdf5
	sed -i \
		-e "s:LHAPDF5:LHAPDF6:g" \
		-e "s:\.LHgrid::g" \
		-e "s:\.LHpdf::g" \
		examples/*.{cc,cmnd} || die
	# ask cflags from root
	sed -i "s:root-config:root-config --cflags:g" examples/Makefile || die
#	if ! use static-libs; then
#		sed -i \
#			-e '/targets.*=$(LIBDIR.*\.a$/d' \
#			-e 's/+=\(.*libpythia8\.\)/=\1/' \
#			Makefile || die
#		sed -i \
#			-e 's:\.a:\.so:g' \
#			examples/Makefile || die
#	fi
}

# TODO: the following optional packages are out of Gentoo tree:
# - EvtGen http://atlas-computing.web.cern.ch/atlas-computing/links/externalDirectory/EvtGen/
# - PowHEG http://powhegbox.mib.infn.it/
# - ProMC  https://github.com/Argonne-National-Laboratory/ProMC/
src_configure() {
	# homemade configure script
	./configure \
		--arch=Linux \
		--cxx=$(tc-getCXX) \
		--enable-shared \
		--prefix="${EPREFIX}/usr" \
		--prefix-lib="$(get_libdir)" \
		--prefix-share="${PYTHIADIR}" \
		$(usex fastjet "--with-fastjet3" "") \
		$(usex gzip "--with-gzip" "") \
		$(usex hepmc "--with-hepmc2" "") \
		$(usex lhapdf "--with-lhapdf6
			--with-lhapdf6-plugin=LHAPDF6.h
			--with-lhapdf6-lib=${EPREFIX}/usr/$(get_libdir)" "") \
		$(usex root "--with-root
			--with-root-include=${EPREFIX}/usr/include/root
			--with-root-lib=${EPREFIX}/usr/$(get_libdir)/root" "") \
		|| die
}

src_test() {
	cd examples || die

	local tests="$(echo main{{01..32},37,38,51,52,54,61,62,73,80})" t
	use hepmc && tests+=" $(echo main{41,42,85,86})"
	use hepmc && use lhapdf && tests+=" $(echo main{43,{87..89}})"
	use lhapdf && tests+=" $(echo main{51..54})"
	use fastjet && tests+=" $(echo main{71,72})"
	use fastjet && use hepmc && use lhapdf && tests+=" $(echo main{81..84})"
	use root && tests+=" main91"
	# Disabled tests:
	# 33	needs PowHEG
	# 46	needs ProMC
	# 48	needs EvtGen
	# 92	generated ROOT dictionary is badly broken

	# some tests need arguments
	local -a args
	args[16]="main16.cmnd"
	args[42]="main42.cmnd hepmcout42.dat"
	args[43]="main43.cmnd hepmcout43.dat"

	# use emake for parallel instead of long runmains
	emake ${tests}
	for t in ${tests}; do
		einfo "Running test ${t}..."
		LD_LIBRARY_PATH="${S}/$(get_libdir):${LD_LIBRARY_PATH}" \
		PYTHIA8DATA="../share/Pythia8/xmldoc/" \
			./"${t}" ${args[t]} > "${t}.out" || die "test ${t} failed"
	done
	emake clean
	rm main*.out *.dat || die
}

src_install() {
	# make install is too broken, much easier to install manually
	dobin bin/pythia8-config
	doheader -r include/*
	dolib lib/*
	insinto "/usr/share/pythia8"
	doins -r share/Pythia8/xmldoc

	echo "PYTHIA8DATA=${PYTHIADIR}/xmldoc" >> 99pythia8
	doenvd 99pythia8

	dodoc AUTHORS GUIDELINES README
	if use doc; then
		dodoc share/Pythia8/pdfdoc/*
		dohtml -r share/Pythia8/htmldoc/*
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	# cleanup
	unset PYTHIADIR
}
