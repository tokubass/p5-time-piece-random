use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Time::Piece::Random',
    AUTHOR              => q{Kouji Tominaga <tokubass@cpan.org>},
    VERSION_FROM        => 'lib/Time/Piece/Random.pm',
    ABSTRACT_FROM       => 'lib/Time/Piece/Random.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Time-Piece-Random-*' },
);
