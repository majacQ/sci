# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Fast and easy statistical learning on NeuroImaging data"
HOMEPAGE="http://nilearn.github.io/"
SRC_URI="https://github.com/nilearn/nilearn/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+plot test"

DEPEND="
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		)
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
RDEPEND="
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scikits_learn[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	plot? ( dev-python/matplotlib[${PYTHON_USEDEP}] )"

# upstream is reluctant to *not* depend on bundled scikits_learn:
# https://github.com/nilearn/nilearn/pull/1398
python_prepare_all() {
	local f
	for f in nilearn/{*/*/,*/,}*.py; do
		sed -r \
			-e '/^from/s/(sklearn|\.|)\.externals\.joblib/joblib/' \
			-e 's/from (sklearn|\.|)\.externals import/import/' \
		-i $f || die
	done

	distutils-r1_python_prepare_all
}

python_test() {
	echo "backend: Agg" > matplotlibrc
	MPLCONFIGDIR=. nosetests -v || die
}
