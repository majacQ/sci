# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Scripts for ncbi-tools++ and SRA postprocessing using taxonomy"
HOMEPAGE="ftp://ftp.ncbi.nih.gov/blast/WGS_TOOLS
	https://www.ncbi.nlm.nih.gov/books/NBK279690/
	https://www.ncbi.nlm.nih.gov/genbank/wgs"
SRC_URI="ftp://ftp.ncbi.nih.gov/blast/WGS_TOOLS/taxid2tsa.pl
	ftp://ftp.ncbi.nih.gov/blast/WGS_TOOLS/taxid2wgs.pl"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"

S="${WORKDIR}"

src_install(){
	cd "${DISTDIR}" || die
	dobin *.pl
}

pkg_postinst(){
	einfo "These scripts are helpful for VDB-enabled blast+ applications"
	einfo "and for tools from SRA toolkit sci-biology/sra_sdk or"
	einfo "sci-biology/sra_toolkit-bin. They are not added to DEPENDENCIES"
	einfo "yet until the packages are stable. Probably you want to download"
	einfo "Please read http://www.ncbi.nlm.nih.gov/books/NBK158899/"
	einfo "and unpack one of the prebuilt binaries from:"
	einfo "https://github.com/ncbi/sra-tools/wiki/Downloads"
}
