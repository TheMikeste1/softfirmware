#!/usr/bin/env python3

from pathlib import Path

from fusesoc.capi2.json_schema import capi2_schema

SCRIPT_DIR = Path(__file__).parent.resolve()

def main():
    with open(SCRIPT_DIR / "fusesoc_schema.json", "w", encoding="utf-8") as fout:
        fout.write(capi2_schema.strip())

if __name__ == "__main__":
    main()
