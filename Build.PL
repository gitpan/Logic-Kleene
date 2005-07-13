use Module::Build;

my $build = Module::Build->new
    (
     module_name => 'logic::kleene',
     license => 'perl',
     requires => {
       'perl'             => '5.6.0',
       'overload'         => 0,
     },
     recommends => {
     },
     build_requires => {
       'Test::More'     => 0,
     },
     script_files       => [
     ],
     create_readme      => ($Module::Build::VERSION >= 0.2702),
     create_makefile_pl => 'traditional',
     dist_author        => 'Robert Rothenberg <rrwo at cpan.org>',
     sign               => 1,
);

$build->create_build_script;

