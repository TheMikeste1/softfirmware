library vunit_lib;
  context vunit_lib.vunit_context;

entity tb_example is
  generic (
    runner_cfg : string
  );
end entity tb_example;

architecture tb of tb_example is

begin

  main : process is
  begin

    test_runner_setup(runner, runner_cfg);
    report "Hello world!";
    test_runner_cleanup(runner); -- Simulation ends here

  end process main;

end architecture tb;
