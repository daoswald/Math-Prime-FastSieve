package Math::Prime::FastSieve;

use 5.006000;
use strict;
use warnings;

use base 'Exporter';

our @ISA = qw(Exporter);


our @EXPORT_OK = qw( primes safe_primes ); # We can export primes().

our @EXPORT    = qw(        ); # Export nothing by default.

our $VERSION = '0.04';


use Inline CPP      => 'DATA',
           VERSION  => '0.04',
           NAME     => 'Math::Prime::FastSieve';

# No real code here.  Everything is implemented in pure C++ using
# Inline::CPP.


1;

=head1 NAME

Math::Prime::FastSieve - Generate a list of all primes less than or equal
to C<$n>. Do it quickly.

While we're at it, supply a few additional tools that a Prime Sieve
facilitates.

=head1 VERSION

Version 0.03


=head1 SYNOPSIS

This module provides an optimized implementation of the Sieve of
Eratosthenes, and uses it to return a reference to an array all primes up to
any integer specified, within the limitations of addressable memory.

Additionally the module provides access to other Prime-related functions
that are facilitated as a by-product of having a really fast Prime
Sieve.

At the time of writing, the C<primes> function will return all primes
up to and including C<$n> faster than any other module I can find on CPAN
(including Math::Prime::XS).  While a segmented sieve (which this isn't) would
extend the range of primes accessible, the fact that this module uses
a bit-sieve means that primes over a billion are easily within reach
of most modern systems.


    # ----------    The simple (and fastest) interface:    ----------
    use Math::Prime::FastSieve qw( primes );

    # Obtain an reference to an array containing all primes less than or
    # equal to 5 Million.
    my $aref = primes( 5_000_000 );



    # ----------   The object (far more flexible) interface.   ----------

    # Create a new sieve and flag all primes less or equal to n.
    my $sieve = Math::Prime::FastSieve::Sieve->new( 5_000_000 );

    # Obtain a ref to an array containing all primes <= 5 Million.
    my $aref = $sieve->primes( 5_000_000 );

    # Obtain a ref to an array containing all primes >= 5, and <= 16.
    my $aref = $sieve->ranged_primes( 5, 16 );

    # Query the sieve: Is 17 prime? Return a true or false value.
    my $result = $sieve->isprime( 17 );

    # Get the value of the nearest prime less than or equal to 42.
    my $less_or_equal = $sieve->nearest_le( 42 );

    # Get the value of the nearest prime greater than or equal to 42.
    my $greater_or_equal = $sieve->nearest_ge( 42 );

    # Count how many primes exist within the sieve (ie, count all primes less
    # than or equal to 5 Million, assuming we instantiated the sieve with
    # Math::Prime::FastSieve::Sieve->new( 5_000_000 );.
    my $num_found = $sieve->count_sieve();

    # Count how many primes fall between 1 and 42 inclusive.
    my $quantity_le = $sieve->count_le( 42 );

    # Return the value of the 42nd prime number.
    my $fourty_second_prime = $sieve->nth_prime( 42 );


=head1 EXPORT

Exports nothing by default.  If you ask nicely it will export the single
subroutine, C<primes>.

    use Math::Prime::FastSieve qw( primes );  # Import primes().
    use Math::Prime::FastSieve;               # No imports.

=head1 SUBROUTINES/METHODS

This module provides two modus operandi.  The simplest also happens to
be the fastest way of generating a list of all primes up to and
including C<$n>.  That is via a direct call to the C<primes($n)>
function.

The more powerful way to use this module is via its object oriented
interface.  With that approach, the constructor C<new($n)> creates a
prime sieve flagging all primes from 2 to C<$n> inclusive, and returns
a Sieve object.  That object may then be queried by way of accessor
methods to get at any of the following:

=over 4

=item * C<primes()>
A list of all primes within the sieve.

=item * C<ranged_primes( $lower, $upper )>
A list of all primes >= C<$lower>, and <= C<$upper>.

=item * C<isprime($n)>
A primality test for any integer within the bounds of the sieve.

=item * C<nearest_le($n)>
Find the nearest prime less than or equal to C<$n> within the bounds of
the sieve.

=item * C<nearest_ge($n)>
Find the nearest prime greater or equal to C<$n> within the bounds of
the sieve.

=item * C<count_sieve()>
A count of all primes in the sieve.

=item * C<count_le($n)>
A a count of all primes less than or equal to C<$n> within the bounds of
the sieve.

=item * C<nth_prime($n)>
Return the C<$n>th prime, within the bounds of the sieve.

=back

Because the sieve is created when the object is instantiated, many of
the tests you might call on the sieve object will execute quite quickly.
Each of the subs and methods documented below will also attempt to describe
the computational and memory complexity of the function.

=head1 The Standard Interface

=head2 Objective

Provide a fast and simple means of generating a big list of prime
numbers.

=head3 primes()

This is a regular function (ie, not an object method).

Pass a positive integer as its parameter.  Returns a reference to an
array of all prime numbers C<2 .. $n>.

This function is implemented in C++ using Inline::CPP, which in turn
binds it to Perl via XS.  The method used is the Sieve of Eratosthenes.
The sieve is one of the fastest known methods of generating a list of
primes up to C<$n>.

This implementation makes several optimizations beyond the cannonical
Sieve, including:

=over 4

=item * Uses a bit vector as a sieve: A memory optimization that allows
the sieve to scale well without consuming so much memory that your
system grinds to a stand-still for large C<$n>s (where "large" depends
on your system, of course).

=item * Only sifts and tests odd integers.

=item * Returns an array-ref rather than a potentially huge (slow) list.

=item * Other micro-optimizations to squeeze a few cycles out here
and there.

=back

The result is a prime number generator that is...fast.  It operates in
O( n log log n ) time, with a O(n) memory growth rate.

=head1 The Object Oriented Interface

=head2 Objective

Where the standard interface wraps the sieve constructor and the sieve
accessor in a single function called C<primes()>, the object oriented
interface places the sieve constructor in
C<Math::Prime::FastSieve::Sieve->new()>, and leaves the interpretation
of the sieve's results to separate accessor methods.  The advantage is
that if you don't really need "a big list", but instead need other
functionality that may be computationally (and memory) cheaper to obtain
from the sieve, you can get at those results without constructing a huge
list of primes.

The standard interface is faster.  But the object interface is still
very fast, and provides greater flexibility.


=head3 new()

Class method of C<Math::Prime::FastSieve::Sieve>  Requires a single
integer parameter that represents the largest value to be held in the
sieve.  For example:

    my $sieve = Math::Prime::FastSieve::Sieve->new( 1_000_000_000 );

This will create a Sieve object that flags all integers from 2 to
1 billion that are prime.

Calling C<new()> is an O(n log log n) operation.  The memory growth is at a
rate that is 1/8th the rate of growth of C<$n>.


=head3 primes()

This works just like the standard C<primes()> function, except that it
is a member function of your Sieve object, and also (behind the scenes)
it doesn't need to create a sieve of prime flags since C<new()> already
did that for you.  You must call C<primes()> with an integer parameter.
The integer must be less than or equal to the integer value previously
passed to the C<new()> constructor.  C<primes()> returns a reference to
an array of all prime numbers from 2 to the integer passed to it.

Passing an out-of-bounds integer will result in a return value of an
array ref pointing to an empty array.

    my $primes_ref = $sieve->primes( 1_000_000_000 );
    my $primes_ref = $sieve->primes( 50 );

The C<primes()> method is an O(n) operation for both time and memory.

=head3 ranged_primes()

This behaves exactly like the C<primes()> method, except that you
specify a lower and upper limit within the bounds of the sieve.  The
return value is a reference to an array holding all prime numbers
greater than or equal to the lower limit, and less than or equal to the
upper limit.

The purpose of this method is to allow you to create a sieve ( with
C<new()> ), and then get results in a segmented form.  The reasons this
may be desirable are two-fold:  First, you may only need a subset.
Second, this gives you finer control over how much memory is gobbled up
by the list returned.  For a huge sieve the sieve's memory footprint is
much smaller than the list of integers that are flagged as prime.  By
dealing with that list in chunks you can have a sieve of 2.14 billion
prime flags, but never hold that big of a list of integers in memory
all at once.

    my $primes_ref = $sieve->ranged_primes( 5, 16 );
    # $primes_ref now holds [ 5, 7, 11, 13 ].

The time complexity of this method is O(n) where 'n' is the upper limit
minus the lower limit.  So a range of 5_000_000 .. 5_000_010 consumes as
much time as 100 .. 110.


=head3 isprime()

Pass a parameter consisiting of a single integer within the range of the
Sieve object.  Returns true if the integer is prime, false otherwise.
If the integer is out of the Sieve object's bounds, the result will be
false.

    if( $sieve->isprime(42) ) {
        say "42 is prime.";
    } else {
        say "42 isn't prime.";
    }

This is an O(1) operation.


=head3 nearest_le()

The C<nearest_le()> method returns the closest prime that is less than
or equal to its integer parameter.  Passing an out of bounds parameter
will return a C<0>.

    my $nearest_less_or_equal = $sieve->nearest_le( 42 );

Since the nearest prime is never very far away, this is an
O( n / ( log n ) ) operation.


=head3 nearest_ge()

Like the C<nearest_le()> method, but this method returns the prime that
is greater than or equal to the input parameter.  If the input param. is
out of range, or if the next prime is out of range, a C<0> is returned.

    my $nearest_greater_or_equal = $sieve->nearest_ge( 42 );

This is also an O( n / ( log n ) ) operation.

By adding one to the return value and passing that new value as a
parameter to the C<nearest_ge()> method again and again in a loop it is
easy to iterate through a list of primes without generating them all
at once.  Of course it's not going to be as fast as getting the big
list all at once, but you can't have everything in life, now can you?


=head3 count_sieve()

Takes no input parameter.  Counts all of the primes in the sieve and
returns the count.  The first time this is called on a Sieve object
the count takes O(n) time.  Subsequent calls benefit from the first
run being cached, and thus become O(1) time.


=head3 count_le()

Pass an integer within the range of the sieve as a parameter.  Return
value is a count of how many primes are less than or equal to that
integer.  If the value passed as a parameter is the same as the size of
the sieve, the results are cached for future calls to C<count_sieve()>.

This is an O(n) operation.


=head3 nth_prime()

This method returns the n-th prime, where C<$n> is the cardinal index in the
sequence of primes.  For example:

    say $sieve->nth_prime(1) # prints 2: the first prime is 2.
    say $sieve->nth_prime(3) # prints 5: the third prime is 5.

If there is no nth prime in the bounds of the sieve C<0> is returned.




=head1 Implementation Notes

The sieve is implemented as a bit sieve using a C++ vector<bool>.  All
integers from 0 to C<$n> are represented based on their index within the sieve
(evens too). A bit sieve is highly efficient from a memory standpoint because
obviously it only consumes one byte per eight integers. It could be
further improved (from a memory standpoint) by only representing odd
integers within the sieve. However, an odds-only sieve would introduce
additional computational cycles inside of a very tight loop, and
consequently degrade time performance.  For that reason I chose to leave
evens in the sieve, doubling the sieve footprint but trimming a lot of
potential computational overhead away.

So, while a bit sieve was used for memory efficiency, just about every
other optimization favored reducing time complexity.

Furthermore, all functions and methods are implemented in C++ by way of
Inline::CPP.  In fact, the sieve itself is never exposed to Perl (this
decision is both a time and memory optimization).

A side effect of using a bit sieve is that the sieve itself actually
requires less memory than the integer list of primes sifted from it.
That means that the memory bottleneck with the C<primes()> function, as
well as with the C<primes()> object method is not, in fact, the sieve,
but the list passed back to Perl via an array-ref.

If you find that your system memory isn't allowing you to call C<primes>
with as big an integer as you wish, use the object oriented interface.
C<new> will generate a sieve up to the largest integer your system
allows (often a little over 2.14 billion).  Then rather than calling
the C<primes> method, use C<nearest_ge> to iterate over the list.
Of course this is slower, but it beats running out of memory doesn't it?


=head1 Installation

There is a dependancy: Inline::CPP (Inline C++).  Inline::CPP has
Inline::C, Inline, and Parse::RecDescent as dependancies.  You also need
Inline::MakeMaker, which is invoked by Makefile.PL in place of
ExtUtils::MakeMaker.

Additionally, your system must have a C++ compiler that is compatible with the
compiler used to build Perl.  In theory it all these dependancies may sound
like a big pain.  In practice, most users should be able to install this
module with the familiar incantations:

    cpan Math::Prime::FastSieve

Or download and unpack the tarball, and...

    perl Makefile.PL
    make
    make test
    make install

Using the cpan shell, cpanm, or cpanplus will have the added benefit of
pulling in and building the dependencies automatically.

=head1 AUTHOR

David Oswald, C<< <davido at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-math-prime-FastSieve at rt.cpan.org>, or through the web interface
at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Math-Prime-FastSieve>.
I will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Math::Prime::FastSieve


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Math-Prime-FastSieve>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Math-Prime-FastSieve>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Math-Prime-FastSieve>

=item * Search CPAN

L<http://search.cpan.org/dist/Math-Prime-FastSieve/>

=back


=head1 ACKNOWLEDGEMENTS

This module is made possible by Inline::CPP, which wouldn't be possible
without the hard work of the folks involved in the Inline and Inline::C
project.

=head1 LICENSE AND COPYRIGHT

Copyright 2011 David Oswald.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

__DATA__

__CPP__

#include <vector>
using namespace std;

/* Class Sieve below.  Perl sees it as a class named
 * "Math::Prime::FastSieve::Sieve".  The constructor is mapped to
 * "new()" within Perl, and the destructor to "DESTROY()".  All other
 * methods are mapped with the same name as declared in the class.
 *
 * Therefore, Perl sees this class approximately like this:
 *
 * package Math::Prime::FastSieve;
 *
 * sub new {
 *     my $class = shift;
 *     my $n     = shift;
 *     my $self = bless {}, $class;
 *     $self->{max_n} = n;
 *     $self->{num_primes} = 0;
 *     # Build the sieve here...
 *     # I won't bother translating it to Perl.
 *     $self->{sieve} = $primes;  // A reference to a bit vector.
 *     return $self;
 *  }
 *
 */


class Sieve
{
    public:
        Sieve             ( int n ); // Constructor. Perl sees "new()".
        ~Sieve            (       ); // Destructor. Seen as "DESTROY()".
        bool isprime      ( int n ); // Test if n is prime.
        SV*  primes       ( int n ); // Return all primes in an aref.
        int  nearest_le   ( int n ); // Return nearest prime <= n.
        int  nearest_ge   ( int n ); // Return nearest prime >= n.
        int  nth_prime    ( int n ); // Return the nth prime.
        int  count_sieve  (       ); // Return number of primes in sieve.
        int  count_le     ( int n ); // Return number of primes <= n.
        SV*  ranged_primes( int lower, int upper );
                  // Return all primes where "lower <= primes <= upper".
    private:
        int           max_n;
        int           num_primes;
        vector<bool>* sieve;
};


// Set up a primes sieve of 0 .. n inclusive.
Sieve::Sieve( int n )
{
    std::vector<bool>* primes = new std::vector<bool>( n + 1, 0 );
    num_primes = 0;
    max_n      = n;
    for( int i = 3; i * i <= n; i+=2 )
        if( ! (*primes)[i] )
            for( int k, j = i; ( k = i * j ) <= n; j++ )
                (*primes)[k] = 1;
    sieve = primes;
}


// Deallocate memory for primes sieve.
Sieve::~Sieve() {
    delete sieve;
}


// Yes or no: Is the number a prime?  Must be within the range of
// 0 through max_n (the upper limit set by the constructor).
bool Sieve::isprime( int n )
{
    if( n < 2 || n > max_n )  return false; // Bounds checking.
    if( n == 2 )              return true;  // 2 is prime.
    if( ! ( n % 2 ) )         return false; // No other evens are prime.
    if( ! ( (*sieve)[n] ) )   return true;  // 0 bit signifies prime.
    return false;                           // default: not prime.
}


// Return a reference to an array containing the list of all primes
// less than or equal to n.  n must be within the range set in the
// constructor.
SV* Sieve::primes( int n )
{
    AV* av = newAV();
    if( n < 2 || n > max_n )
        return newRV_noinc( (SV*) av );
    av_push( av, newSViv( 2 ) );
    num_primes = 1; // Count 2; it's prime.
    for( int i = 3; i <= n; i += 2 )
        if( ! (*sieve)[i] ) {
            av_push( av, newSViv( i ) );
            num_primes++;   // Cache the number of primes generated.
        }
    return newRV_noinc( (SV*) av );
}

SV* Sieve::ranged_primes( int lower, int upper )
{
    AV* av = newAV();
    if(
        upper > max_n ||        // upper exceeds upper bound.
        lower > max_n ||        // lower exceeds upper bound.
        upper < 2     ||        // No possible primes.
        lower < 0     ||        // lower underruns bounds.
        lower > upper ||        // zero-width range.
        ( lower == upper && lower > 2 && !( lower % 2 ) ) // Even.
    )
        return newRV_noinc( (SV*) av );  // No primes possible.
    if( lower <= 2 && upper >= 2 )
        av_push( av, newSViv( 2 ) );     // Lower limit needs to be odd
    if( lower < 3 ) lower = 3;           // Lower limit cannot < 3.
    if( ( upper - lower ) > 0 && ! ( lower % 2 ) ) lower++;
    for( int i = lower; i <= upper; i += 2 )
        if( ! (*sieve)[i] )
            av_push( av, newSViv( i ) );
    return newRV_noinc( (SV*) av );
}


// Find the nearest prime less than or equal to n.  Very fast.
int Sieve::nearest_le( int n )
{
    if( n < 2 || n > max_n ) return 0; // Bounds checking.
    if( n == 2 ) return 2;             // 2 is the only even prime.
    if( ! ( n % 2 ) ) n--;             // Result has to be odd.
    while( n > 2 )
    {
        if( ! (*sieve)[n] ) return n;
        n-=2;  // Only test odds.
    }
    return 0; // We should never get here.
}


// Find the nearest prime greater than or equal to n.  Very fast.
int Sieve::nearest_ge( int n )
{
    if( n > max_n ) return 0;           // Bounds checking.
    if( n <= 2 ) return 2;              // 2 is only even prime.
    if( ! ( n % 2 ) ) n++;              // Start with an odd number.
    while( n <= max_n )
    {
        if( ! (*sieve)[n] ) return n;
        n+=2; // Only test odds.
    }
    return 0;   // We've run out of sieve to test.
}


// Since we're only storing the sieve (not the primes list), this is a
// linear time operation: O(n).
int Sieve::nth_prime( int n )
{
    if( n <  1     ) return 0; // Why would anyone want the 0th prime?
    if( n >  max_n ) return 0; // There can't be more primes than sieve.
    if( n == 1     ) return 2; // We have to handle the only even prime.
    int count = 1;
    for( int i = 3; i <= max_n; i += 2 )
    {
        if( ! (* sieve)[i] ) count++;
        if( count == n ) return i;
    }
    return 0;
}


// Return the number of primes in the sieve.  Once results are
// calculated, they're cached.  First time through is O(n).
int Sieve::count_sieve ()
{
    if( num_primes > 0 ) return num_primes;
    num_primes = this->count_le( max_n );
    return num_primes;
}


// Return the number of primes less than or equal to n.  If n == max_n
// the data member num_primes will be set.
int Sieve::count_le( int n )
{
    if( n <= 1 || n > max_n ) return 0;
    int count = 1;      // 2 is prime. Count it.
    for( int i = 3; i <= n; i+=2 )
        if( !(*sieve)[i] ) count++;
    if( n == max_n && num_primes == 0 ) num_primes = count;
    return count;
}


// ---------------- For export: Not part of Sieve class ----------------

/* Sieve of Eratosthenes.  Return a reference to an array containing all
 * prime numbers less than or equal to search_to.
 */


SV* primes( int search_to )
{
    AV* av = newAV();

    if( search_to < 2 )
        return newRV_noinc( (SV*) av );
    av_push( av, newSViv(2) );
    std::vector<bool> primes( search_to + 1, 0 );
    for( int i = 3; i * i <= search_to; i+=2 )
        if( ! primes[i] )
            for( int k, j = i; ( k = i * j ) <= search_to; j++ )
                primes[ k ] = 1;
    for( int i = 3; i <= search_to; i+=2 )
        if( ! primes[i] ) av_push( av, newSViv(i) );
    return newRV_noinc( (SV*) av );
}

