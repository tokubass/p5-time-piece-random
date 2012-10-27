package Time::Piece::Random;

use 5.006;
use strict;
use warnings;
use Time::Piece 1.20;
use Carp ();
use Class::Accessor::Lite ( rw => [qw/ format placeholder start end input_start input_end /] );

=head1 NAME

Time::Piece::Random - create Time::Piece object at random in the specified range

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
our $FORMAT = '%Y-%m-%d %H:%M:%S';
our $PLACEHOLDER = '?'; # todo

sub strptime {
    Time::Piece->localtime->strptime(@_);
};

sub new {
    my ($class, $arg)  = @_;
    Carp::croak 'please input start or end time' unless ($arg);
    my $self = bless { }, $class;

    if ( $arg =~ /\A[0-9 :-]+\z/ ) {
        $arg = { start => $arg, end => $arg };
    }

    if ( ref $arg eq 'HASH' ) {
        Carp::croak 'please input start or end time' if ( !$arg->{start} && !$arg->{end} );
        $self->input_start($arg->{start});
        $self->input_end($arg->{end});
        $self->create_start;
        $self->create_end;
    }

    return $self;
    
}


sub create_start {
    my $self = shift;
    if ( ref $self->input_start  eq 'Time::Piece' ) {
        return $self->start( $self->input_start );
    }
     
    my @part = split('[- :]', $self->input_start );
    
    if ( @part == 6 ) {
        return $self->start(strptime($self->input_start, $FORMAT));
    }else{
        my $short_format = substr($FORMAT, 0, scalar @part * 3 );
        my $tp = strptime($self->input_start, $short_format); 
        $self->start( $tp );
    }


}

sub create_end {
    my $self = shift;
    if ( ref $self->input_end  eq 'Time::Piece' ) {
        return $self->end( $self->input_end );
    }
     
    my @part = split('[- :]', $self->input_end );
    
    if ( @part == 6 ) {
        return $self->end(strptime($self->input_end, $FORMAT));
    }else{
        push(@part, undef) while @part == 6;
        my %hash;
        @hash{qw/Y m d H M S/} = @part; 
        $hash{m} ||= 12;
        $hash{d} ||= strptime("$part[0]-12", '%Y-%m')->month_last_day;
        $hash{H} ||= 23;
        $hash{M} ||= 59;
        $hash{S} ||= 59;

        my $date = join('-', @hash{qw/Y m d/});
        my $time = join(':', @hash{qw/H M S/});
        return $self->end( strptime("$date $time", $FORMAT) ); 
    }
}

sub get {
    my ($self,$diff) = @_; 
    unless ($diff) {
        $diff = $self->end->epoch - $self->start->epoch;
    }
    return Time::Piece->new( $self->start->epoch + int(rand($diff)) );
}

sub get_multi {
    my ($self,$count) = @_;
    my $diff = $self->end->epoch - $self->start->epoch;
    return map { $self->get($diff); } (1..$count);
}

# for placeholder
# sub Y {}
# sub m { }
# sub d { }
# sub H { }
# sub M { }
# sub S { }



=head1 SYNOPSIS

    use Time::Piece::Random;

    # return Time::Piece Object
    Time::Piece::Random->new({ start => '2012-01-01', end =>'2012-02-01' })->get; # 2012-01-01 00:00:00 ~ 2012-02-01 23:59:59
    Time::Piece::Random->new({ start => '2012-01-01'})->get; 2012-05-15 00:00:00 ~ now
    Time::Piece::Random->new({ end => '2012-05-15' })->get; now ~ 2012-05-15 23:59:59
    Time::Piece::Random->new('2012-05-01')->get; # 2012-05-01 00:00:00 ~ 2012-05-01 23:59:59
    Time::Piece::Random->new('2012-05')->get;    # 2012-05-01 00:00:00 ~ 2012-05-31 23:59:59
    Time::Piece::Random->new('2012')->get;       # 2012-01-01 00:00:00 ~ 2012-12-31 23:59:59

    my $tpr =  Time::Piece::Random->new('2012-??-01 00:00:00'); #todo
    $tpr->get; #2012-01-01 00:00:00 or 2012-02-01 00:00:00 or ..... 2012-12-01 00:00:00

    
    my $tp  = Time::Piece->new;
    my $tp2 = $tp + ONE_DAY;
    Time::Piece::Random->new({ start => $tp, end => tp2 });


=head1 SUBROUTINES/METHODS

=head2 new


=head2 create_start


=head2 create_end


=head2 get


=head2 get_multi


=head1 AUTHOR

Kouji Tominaga, C<< <tokubass at cpan.org> >>

=head1 SEE ALSO

L<http://search.cpan.org/perldoc?DateTime%3A%3AEvent%3A%3ARandom>


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Kouji Tominaga.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Time::Piece::Random
