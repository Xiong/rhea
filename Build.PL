use 5.014002;   # 5.14.2    # 2012  # pop $arrayref, copy s///r
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'App::Rhea',
    license             => 'artistic_2',
    dist_author         => 'Xiong Changnian <xiong@cpan.org>',
    dist_version_from   => 'lib/App/Rhea.pm',
    configure_requires  => { 
        'Module::Build'             => 0.38, 
    },
    requires            => {
        'perl'                      => 5.014002,
        'version'                   => 0.99,
#~         'Scalar::Util'              => 0,
#~         'overload'                  => 0,
#~         ''  => 0,
    },
    recommends          => {
        'Devel::Comments'           => '1.1.4',
        'Test::Trap'                => '0.2.1',
    },
    build_requires      => {
        'Test::More'                => 0.94,
    },
    add_to_cleanup      => [ 'App-Rhea-*' ],
    meta_merge          => {
        resources           => {
            repository          => 'http://github.com/Xiong/rhea',
        },
        keywords            => [ qw(
            Minetest    game    configuration manager
            git     submodules      mods    conf    config
        ) ],
    },
);

$builder->create_build_script();
exit(0);
