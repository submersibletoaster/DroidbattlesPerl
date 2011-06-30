use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Droidbattles',
    license             => 'perl',
    dist_author         => q{Andrew Bramble <bramble@cpan.org>},
    dist_version_from   => 'lib/Droidbattles.pm',
    build_requires => {
        'Test::More' => 0,
        'Parse::Yapp' => 0,
    },
    requires => {
        'Algorithm::QuadTree' => 0,
        'Math::Trig' => 0,
        'Class::XSAccessor' => 0,
        'Carp' => 0,
        
    },
    add_to_cleanup      => [ 'Droidbattles-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
