# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="AMBER99SBnmr1 force field (Lindorff-Larsen et al., Proteins 78, 1950-58, 2010)"
HOMEPAGE="https://research.chemistry.ohio-state.edu/bruschweiler/protein-force-field/"
SRC_URI="http://research.chemistry.ohio-state.edu/bruschweiler/files/2013/09/nmr1.tar -> ${P}.tar"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"

RESTRICT="strip binchecks"

src_install() {
	insinto /usr/share/gromacs/top/
	dodoc */*.doc
	rm */*.doc || die
	doins -r *
}
