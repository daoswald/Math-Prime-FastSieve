## no critic(RCS,VERSION,interpolation)
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Math::Prime::FastSieve',
    VERSION_FROM     => 'lib/Math/Prime/FastSieve.pm',
    ABSTRACT_FROM    => 'lib/Math/Prime/FastSieve.pm',
    AUTHOR           => 'David Oswald <davido [@at] cpan [d.o.t] org>',
    LICENSE          => 'artistic',
    MIN_PERL_VERSION => '5.008000',
    PREREQ_PM        => {
        'Inline::CPP' => '0.68',
        'Inline'      => '0.78',
        'Inline::C'   => '0.67',
        'Inline::Module' => '0.18',
    },
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '7.04',
    },
    BUILD_REQUIRES => {
        'ExtUtils::MakeMaker' => '7.04',
        'Test::More'          => '1.001009',
        'English'             => '0',
    },
    META_MERGE => {
        provides => {
            'Math::Prime::FastSieve' => {
                file    => 'lib/Math/Prime/FastSieve.pm',
                version => '0.19',
            },
        },
    },
    postamble => {
        inline => {
            module => 'Math::Prime::FastSieve',
            stub   => 'Math::Prime::FastSieve::Inline',
            ilsm   => 'Inline::CPP',
        },
    },
);

