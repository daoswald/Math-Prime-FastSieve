## no critic(RCS,VERSION,interpolation)
use strict;
use warnings;

use lib 'inc';
use ExtUtils::MakeMaker;
use Inline::Module;

WriteMakefile(
    NAME             => 'Alt::Math::Prime::FastSieve::Inline',
    VERSION_FROM     => 'lib/Alt/Math/Prime/FastSieve/Inline.pm',
    ABSTRACT_FROM    => 'lib/Alt/Math/Prime/FastSieve/Inline.pm',
    AUTHOR           => 'David Oswald <davido [@at] cpan [d.o.t] org>',
    LICENSE          => 'artistic',
    MIN_PERL_VERSION => '5.008001',
    PREREQ_PM        => {
    },
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '7.04',
    },
    BUILD_REQUIRES => {
        'ExtUtils::MakeMaker' => '7.04',
        'Test::More'          => '1.001009',
    },
    META_MERGE   => {
        'meta-spec' => { version => 2 },
        prereqs     => {
            develop => {
                requires => {
                    'Inline::CPP'    => '0.69',
                    'Inline'         => '0.78',
                    'Inline::C'      => '0.67',
                    'Inline::Module' => '0.21',
                },
            },
        },
        provides => {
            'Alt::Math::Prime::FastSieve::Inline' => {
                file    => 'lib/Alt/Math/Prime/FastSieve/Inline.pm',
                version => '0.04',
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

