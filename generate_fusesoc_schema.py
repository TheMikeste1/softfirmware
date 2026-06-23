#!/usr/bin/env python3

import json
from pathlib import Path

from fusesoc.capi2.json_schema import capi2_schema

SCRIPT_DIR = Path(__file__).parent.resolve()

def main():
    schema = json.loads(capi2_schema.strip())
    schema["properties"]["CAPI=2"] = {
      "description": "Specifies the version of CAPI",
      "type": "null"
    }

    with open(SCRIPT_DIR / "fusesoc_schema.json", "w", encoding="utf-8") as fout:
        json.dump(schema, fout, indent=2)

if __name__ == "__main__":
    main()
