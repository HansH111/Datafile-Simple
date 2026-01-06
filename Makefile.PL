use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Datafile::Simple',
    AUTHOR           => 'Hans Harder <hans@atbas.org>',
    VERSION_FROM     => 'lib/Datafile/Array.pm',  # versions are the same in both
    ABSTRACT         => 'Lightweight pure-Perl data file handlers for array/tabular and hash/INI data',
    LICENSE          => 'perl_5',
    MIN_PERL_VERSION => '5.010',

    PREREQ_PM => {
        # No external dependencies — pure core Perl
    },

    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url  => 'https://github.com/HansH111/Datafile-Simple.git',
                web  => 'https://github.com/HansH111/Datafile-Simple',
            },
            bugtracker => {
                web => 'https://github.com/HansH111/Datafile-Simple/issues',
            },
        },
        provides => {
	        # Primary package matching distribution name
            'Datafile::Simple' => {
                file    => 'lib/Datafile/Array.pm',  # can point to any file in the dist
                version => '1.05',
            },
            'Datafile::Array' => {
                file    => 'lib/Datafile/Array.pm',
                version => '1.05',
            },
            'Datafile::Hash' => {
                file    => 'lib/Datafile/Hash.pm',
                version => '1.05',
            },
        },
    },

    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    clean => { FILES => 'Datafile-Simple-*' },

    test => { TESTS => 't/*.t' },
);
