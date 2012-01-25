# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs versionator alternatives-2

ACML_INST_DIR=opt/${PN}${PV}
QA_PREBUILT="${ACML_INST_DIR}/*/lib/*"

MYP=${PN}-$(replace_all_version_separators -)

DESCRIPTION="AMD Core Math Library for x86 and amd64 CPUs"
HOMEPAGE="http://developer.amd.com/cpu/libraries/acml/Pages/default.aspx"

# here we go for the url mess
FCOMP64=""
URI="http://download2-developer.amd.com/amd/ACML"
for fcomp in gfortran ifort open64 pgi; do
	FCOMP64="${FCOMP64} ${fcomp}? ( ${URI}/${MYP}-${fcomp}-64bit.tgz
			int64? ( ${URI}/${MYP}-${fcomp}-64bit-int64.tgz ) )"
done
SRC_URI="
	amd64? ( ${FCOMP64}
		!gfortran? ( !ifort? ( !open64? ( !pgi? (
				${URI}/${MYP}-gfortran-64bit.tgz
				int64? ( ${URI}/${MYP}-gfortran-64bit-int64.tgz ) ) ) ) ) )"

LICENSE="ACML"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="doc examples gfortran ifort int64 open64 openmp pgi static-libs test"
RESTRICT="strip mirror"

DEPEND="test? ( virtual/fortran )"
RDEPEND="virtual/fortran"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	unpack ./contents-acml-*.tgz
	use openmp || rm -rf *_mp
}

src_test() {
	local fdir d
	for fdir in */examples; do
		einfo "Testing acml in ${fdir}"
		for d in . acml_mv; do
			pushd ${fdir}/${d} > /dev/null
			emake ACMLDIR="${S}/${fdir%/examples}"
			emake clean
			popd > /dev/null
		done
	done
}

src_install() {
	# install libraries, pkgconfig file and eselect files for each profile
	# fdef will be the default (gfortran if available) to be in path
	local prof libs fdir libdir x fdef
	for fdir in */lib; do
		fdir=$(dirname ${fdir})
		prof=acml$(echo ${fdir} | sed \
			-e 's:mp:openmp:' \
			-e 's:_:-:g' \
			-e 's:\([a-z]*\)\(32\|64\)\(-openmp\|\)\(-int64\|\):\2\4-\1\3:')
		use examples || rm -rf ${fdir}/examples
		use static-libs || rm -f ${fdir}/lib/*.a
		dodir /${ACML_INST_DIR}
		cp -pPR ${fdir} "${ED}"/${ACML_INST_DIR}
		libs="$(find ${fdir} -name \*.so -printf '%f ' | sed -e 's:lib:-l:g' -e 's:\.so::g')"
		cat <<-EOF > ${prof}.pc
			prefix=${EPREFIX}/${ACML_INST_DIR}/${fdir}
			libdir=\${prefix}/lib
			includedir=\${prefix}/include
			Name: ${prof}
			Description: ${DESCRIPTION}
			Version: ${PV}
			URL: ${HOMEPAGE}
			Libs: -L\${libdir} ${libs}
			Cflags: -I\${includedir}
		EOF
		libdir=$(get_libdir)
		insinto /usr/${libdir}/pkgconfig
		doins ${prof}.pc
		for x in blas lapack; do
			alternatives_for ${x} ${prof} 0 \
				/usr/${libdir}/pkgconfig/${x}.pc ${prof}.pc \
				/${ACML_INST_DIR}/${libdir} ${fdir}/lib
		done
		[[ ${fdef} = gfortran${libdir#lib} ]] || fdef=${fdir}
	done

	# install env file
	use openmp && [[ ${fdef} != *_mp ]] && fdef=${fdef}_mp
	echo -n > 35acml "LDPATH=${EPREFIX}/${ACML_INST_DIR}/$(get_libdir)"
	dosym ${fdef}/lib /${ACML_INST_DIR}/$(get_libdir)
	doenvd 35acml

	insinto /${ACML_INST_DIR}
	# info files go to standard /usr/share/info to avoid more env variables
	doinfo Doc/*info*
	rm Doc/*EULA* Doc/*info*
	use doc || rm -rf Doc/*.pdf Doc/acml.html Doc/html
	doins -r Doc ReleaseNotes*
}
