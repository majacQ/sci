# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN="${PN%-bin}"
MY_P="${MY_PN}_v${PV}"

DESCRIPTION="SSAHA2: Sequence Search and Alignment by Hashing Algorithm"
HOMEPAGE="https://www.sanger.ac.uk/tool/ssaha2-0/"
SRC_URI="
	x86? ( ftp://ftp.sanger.ac.uk/pub4/resources/software/${MY_PN}/${MY_P}_i686.tgz )
	amd64? ( ftp://ftp.sanger.ac.uk/pub4/resources/software/${MY_PN}/${MY_P}_x86_64.tgz )
	ftp://ftp.sanger.ac.uk/pub4/resources/software/ssaha2/samflag.c
	ftp://ftp.sanger.ac.uk/pub4/resources/software/ssaha2/ssaha2-manual.pdf"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"

QA_PREBUILT="*"

src_unpack() {
	default
	use x86 && export S="${WORKDIR}"/${MY_P}_i686
	use amd64 && export S="${WORKDIR}"/${MY_P}_x86_64
}
src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o samflag "${DISTDIR}"/samflag.c || die "Failed to compile samflags"
}

src_install() {
	dobin samflag ssaha2 ssaha2Build ssahaSNP
	dodoc README "${DISTDIR}"/ssaha2-manual.pdf
	einstalldocs
}
