# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="parallel multi-FASTA file processing tool from TIGR Gene Indices project tools"
HOMEPAGE="https://web.archive.org/web/20140726030702/http://compbio.dfci.harvard.edu/tgi/software/"
SRC_URI="ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	newdoc README README.${PN}
}
