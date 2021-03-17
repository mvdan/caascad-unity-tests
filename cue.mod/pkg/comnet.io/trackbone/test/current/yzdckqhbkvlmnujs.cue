package test

import (
	tb "comnet.io/trackbone"
)

source_local: tb.#LocalSource & {
	basedir: configsPath
}

source_git_tag: tb.#GitSource & {
	url:  "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/trackbone.git"
	path: "test/configurations/config_null"
	tag:  "0.1.1"
}

source_git_sha: tb.#GitSource & {
	url:    "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/trackbone.git"
	path:   "test/configurations/config_null"
	branch: "master"
	sha:    "27882cab6c61239510806d7c8014cd909a95943a"
}
