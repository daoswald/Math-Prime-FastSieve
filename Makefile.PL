use 5.006000;
use Inline::MakeMaker;

WriteMakefile(
    NAME              	=>	'Math::Prime::FastSieve',
    VERSION_FROM      	=>	'lib/Math/Prime/FastSieve.pm',
    ABSTRACT_FROM		=>	'lib/Math/Prime/FastSieve.pm',
    AUTHOR				=>	'David Oswald <daoswald@cpan.org>',
    PREREQ_PM         	=>	{
								'Inline::CPP' 			=> 0.33
							},
    BUILD_REQUIRES		=>	{
								'ExtUtils::MakeMaker'	=> 6.62,
								'Inline::MakeMaker'		=> 0.45,
							},
    CONFIGURE_REQUIRES	=>	{
								'Inline::MakeMaker'		=> 0.45,
								'ExtUtils::MakeMaker'	=> 6.62,
							},
);
