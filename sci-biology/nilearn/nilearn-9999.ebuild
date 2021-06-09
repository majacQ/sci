# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 git-r3

DESCRIPTION="Fast and easy statistical learning on NeuroImaging data"
HOMEPAGE="http://nilearn.github.io/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/nilearn/nilearn"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="+plot test"

DEPEND="
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scikits_learn[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	plot? ( dev-python/matplotlib[${PYTHON_USEDEP}] )"

python_test() {
	echo "backend: Agg" > matplotlibrc
	MPLCONFIGDIR=. nosetests -v || die
}
