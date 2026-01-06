# Datafile::Simple - README

**Datafile::Simple** is a lightweight pure-Perl distribution containing two complementary modules for handling common data files:

- **Datafile::Array** – For tabular/delimited data (like CSV or fixed-format files)
- **Datafile::Hash**  – For key-value and INI-style configuration files with sections

Both modules share the same design philosophy:
- No external dependencies
- Safe atomic writes (temp file + rename)
- Consistent return values and error handling
- Verbose messaging support
- UTF-8 encoding

[![Perl](https://img.shields.io/badge/perl-5.006%2B-brightgreen)](https://www.perl.org/)
[![License](https://img.shields.io/badge/license-Perl-orange)](https://dev.perl.org/licenses/)

## Installation

    perl Makefile.PL
    make
    make test
    make install

## Modules

### Datafile::Array

Handles reading and writing delimited data files with optional CSV quoting, headers, and prefix lines.

#### SYNOPSIS

    use Datafile::Array qw(readarray writearray parse_csv_line);

    my @records;
    my @fields;

    my ($count, $msgs) = readarray('data.txt', \@records, \@fields, {
        delimiter    => ';',
        csvquotes    => 1,        # full CSV support with multi-line
        has_headers  => 1,
        prefix       => 1,        # H/R prefix mode
        trim_values  => 1,
        verbose      => 1,
    });

    writearray('data.txt', \@records, \@fields, {
        header  => 1,
        prefix  => 1,
        backup  => 1,
        comment => 'Exported on ' . scalar localtime,
    });

    # Standalone CSV parsing
    my @parts = parse_csv_line('a,"b,c","d""e"', ',');

#### FUNCTIONS

- **readarray($file, $data_ref, $fields_ref, \%opts)**  
  Returns `($record_count, \@messages)`

- **writearray($file, $data_ref, $fields_ref, \%opts)**  
  Returns `($record_count, \@messages)`

- **parse_csv_line($line, [$delimiter = ','])**  
  Lightweight standalone CSV line parser.  
  Handles quoted fields, escaped quotes (""), fields containing delimiter/newlines.  
  Lenient on unclosed quotes. Returns array of fields.

#### KEY OPTIONS

- delimiter       => ';'     (default)
- csvquotes       => 0 | 1   (enable full CSV parsing)
- has_headers     => 1       (expect header line(s))
- prefix          => 0 | 1   (H/R line prefix mode)
- key_fields      => 1       (composite keys for hash mode)
- trim_values     => 1
- comment_char    => '#'
- skip_empty      => 1
- search          => undef   (filter lines)
- verbose         => 0
- header          => 0 | 1   (writearray: write header)
- backup          => 0 | 1   (writearray: keep .bak)
- prot            => 0660    (writearray: file permissions)
- comment         => undef   (writearray: top comments)

### Datafile::Hash

Handles flat key-value files and full INI-style files with multi-level sections.

#### SYNOPSIS

    use Datafile::Hash qw(readhash writehash);

    my %config;

    # INI with nested sections
    readhash('config.ini', \%config, {
        delimiter => '=',      # triggers INI mode
        group     => 2,        # nested hashes (default)
    });

    # $config{database}{host} = 'localhost'

    # Flat file
    readhash('settings.txt', \%config, {
        delimiter => '=',
        group     => 0,        # ignore sections, flat hash
    });

    writehash('config.ini', \%config, {
        backup  => 1,
        comment => ['Auto-generated', scalar localtime],
    });

#### FUNCTIONS

- **readhash($file, $hash_ref, \%opts)**  
  Returns `($entry_count, \@messages)`

- **writehash($file, $hash_ref, \%opts)**  
  Returns `($entry_count, \@messages)`

#### KEY OPTIONS

- delimiter       => '='     (default)  
  '=' or ':' → INI mode with sections and quoting  
  Anything else → flat key-value mode

- group           => 2       (default)  
  0 = flat hash (ignore sections)  
  1 = dotted keys (section.sub.key)  
  2 = nested hashes (recommended)

- key_fields      => 1       (flat mode only)
- skip_empty      => 1
- skip_headers    => 0       (skip leading banner lines)
- comment_char    => '#'
- search          => undef
- verbose         => 0
- backup          => 0 | 1   (writehash)
- comment         => undef   (writehash: top comments)
- prot            => 0660    (writehash)

INI mode features:
- [section.subsection] headers
- Quoted values with escaped quotes (\")
- Automatic quoting on write when needed

## Common Features

Both modules:
- Use UTF-8 encoding
- Skip comment lines (default #)
- Support search filtering
- Return verbose messages when requested
- Perform safe atomic writes
- Gracefully handle I/O errors (return errors instead of die)

## License

This distribution is free software. You can redistribute it and/or modify it under the same terms as Perl itself.

Version: 1.05  
Date: January 2026
