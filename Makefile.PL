use strict;
use warnings;

use Inline::MakeMaker;

WriteMakefile(
    NAME             => 'Math::Prime::FastSieve',
    VERSION_FROM     => 'lib/Math/Prime/FastSieve.pm',
    ABSTRACT_FROM    => 'lib/Math/Prime/FastSieve.pm',
    AUTHOR           => 'David Oswald <davido [@at] cpan [d.o.t] org>',
    LICENSE          => 'artistic',
    MIN_PERL_VERSION => '5.006000',
    PREREQ_PM        => {
        'Inline::CPP' => '0.39',
        'Inline'      => '0.50',
        'Inline::C'   => '0.50',
    },
    CONFIGURE_REQUIRES => {
        'Inline::MakeMaker'   => '0.50',
        'ExtUtils::MakeMaker' => '6.62',
    },
    BUILD_REQUIRES => {
        'ExtUtils::MakeMaker' => '6.62',
        'Test::More'          => '0.98',
        'English'             => '0',
    },
    META_MERGE => {
        provides => {
            'Math::Prime::FastSieve' => {
                file    => 'lib/Math/Prime/FastSieve.pm',
                version => '0.09'
            },
        },
    },
);
