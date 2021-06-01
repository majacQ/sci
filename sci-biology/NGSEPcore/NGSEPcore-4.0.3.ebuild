# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="NGSEP (CNV and indel discovery)"
HOMEPAGE="https://sourceforge.net/p/ngsep/wiki/Home
	https://github.com/NGSEP/NGSEPcore"
SRC_URI="https://sourceforge.net/projects/ngsep/files/SourceCode/NGSEPcore_${PV}.tar.gz
	https://sourceforge.net/projects/ngsep/files/training/ManualNGSEP_v${PV}.pdf -> ${P}_UserManual.pdf
	https://sourceforge.net/projects/ngsep/files/training/Tutorial.txt -> ${P}_Tutorial.txt
	https://sourceforge.net/projects/ngsep/files/training/QuickStart.txt -> ${P}_QuickStart.txt"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jdk-1.8:="
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}_${PV}"

src_prepare(){
	# recent versions of htsjdk now use gradle,
	# which is not supported by portage
	#rm lib/htsjdk-2.22.jar || die
	# TODO: package dev-java/jsci
	#rm lib/jsci-core.jar || die
	default
}

src_compile(){
	emake -j1
}

src_install(){
	java-pkg_dojar *.jar lib/*.jar
	dodoc "${DISTDIR}"/${P}_UserManual.pdf \
	"${DISTDIR}"/${P}_Tutorial.txt \
	"${DISTDIR}"/${P}_QuickStart.txt \
	README.txt
}
