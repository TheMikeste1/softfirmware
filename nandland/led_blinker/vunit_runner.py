from argparse import Namespace

from edalize.vunit_hooks import VUnitHooks
from vunit import VUnit, VUnitCLI
from vunit.ui import Library, Results


class VUnitRunner(VUnitHooks):
    def __init__(self):
        super().__init__()
        self.args = Namespace()

    def create(self) -> VUnit:
        cli = VUnitCLI()
        cli.parser.add_argument("--with-coverage", action="store_true")
        self.args = cli.parse_args()

        vu = VUnit.from_args(self.args, compile_builtins=False)
        vu.add_vhdl_builtins()
        vu.add_osvvm()

        # Silence GHDL warnings for VUnit internals
        # Only affects files already added -- must come after the two
        # lines above, before FuseSoC's own sources get added later.
        vu.set_compile_option(
            "ghdl.a_flags",
            ["-Wno-hide", "-Wno-shared"] # pyright: ignore[reportArgumentType]
        )
        return vu

    def handle_library(self, logical_name: str, vu_lib: Library):
        _ = logical_name

        vu_lib.set_compile_option("ghdl.a_flags", ["-Wall"], allow_empty=True)
        if self.args.with_coverage:
            vu_lib.set_compile_option("enable_coverage", True, allow_empty=True)
            vu_lib.set_sim_option("enable_coverage", True, allow_empty=True)

    def main(self, vu: VUnit):
        def post_run(results: Results):
            if self.args.with_coverage:
                results.merge_coverage(file_name="coverage_merged")
        vu.main(post_run=post_run)
