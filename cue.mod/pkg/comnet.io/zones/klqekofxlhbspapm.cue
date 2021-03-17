package zones

import (
	"encoding/json"
	"tool/file"
)

command: generate: {
	task: "zone.json": {
		file.Create & {
			filename: "zones.json"
			contents: json.Indent(json.Marshal(zones), "", "  ")
		}
	}
}
