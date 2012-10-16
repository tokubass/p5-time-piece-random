use strict;
use warnings;
use Test::More;
use Time::Piece::Random;

subtest empty_input => sub {
    eval { Time::Piece::Random->new() };
    my $err = $@;
    ok( $err =~ /^please input start or end time at .*$/);

    eval { Time::Piece::Random->new() };
    my $err2 = $@;
    ok( $err2 =~ /^please input start or end time at .*$/);

};

subtest time_piece_object => sub {
    my $start = Time::Piece->strptime('2012-01-01 00:00:00', '%Y-%m-%d %H:%M:%S');
    my $end   = Time::Piece->strptime('2012-01-31 23:59:59', '%Y-%m-%d %H:%M:%S');
    
    my $rand_date = Time::Piece::Random->new({
        start => $start,
        end   => $end,
    })->get;

    ok($rand_date >= $start);
    ok($rand_date <= $end);

};


subtest explicit_range => sub {

    my $tpr =  Time::Piece::Random->new({
        start => '2012-01-01 00:00:00',
        end   => '2012-01-31 23:59:59'
    });
    note $tpr->start->strftime('%Y-%m-%d %H:%M:%S');
    note $tpr->end->strftime('%Y-%m-%d %H:%M:%S');

    my $rand_date = $tpr->get;

    ok($rand_date >= Time::Piece->strptime('2012-01-01 00:00:00', '%Y-%m-%d %H:%M:%S'));
    ok($rand_date <= Time::Piece->strptime('2012-01-31 23:59:59', '%Y-%m-%d %H:%M:%S'));

};

subtest only_date_range => sub {
    my $tpr = Time::Piece::Random->new({
        start => '2012-01-01',
        end   => '2012-01-31'
    });
    my $rand_date = $tpr->get;
    note 'start:',$tpr->start->strftime('%Y-%m-%d %H:%M:%S');
    note 'end:  ',$tpr->end->strftime('%Y-%m-%d %H:%M:%S');
    ok($rand_date >= Time::Piece->strptime('2012-01-01 00:00:00', '%Y-%m-%d %H:%M:%S'));
    ok($rand_date <= Time::Piece->strptime('2012-01-31 23:59:59', '%Y-%m-%d %H:%M:%S'));

};

subtest short_date_range => sub {
    my $tpr = Time::Piece::Random->new({
        start => '2012-01',
        end   => '2012-01'
    });
    my $rand_date = $tpr->get;
    note 'start:', $tpr->start->strftime('%Y-%m-%d %H:%M:%S');
    note 'end  :',$tpr->end->strftime('%Y-%m-%d %H:%M:%S');
    ok($rand_date >= Time::Piece->strptime('2012-01-01 00:00:00', '%Y-%m-%d %H:%M:%S'));
    ok($rand_date <= Time::Piece->strptime('2012-01-31 23:59:59', '%Y-%m-%d %H:%M:%S'));

};

subtest more_short_date_range => sub {
    my $tpr = Time::Piece::Random->new({
        start => '2012',
        end   => '2012'
    });
    my $rand_date = $tpr->get;
    note 'start:', $tpr->start->strftime('%Y-%m-%d %H:%M:%S');
    note 'end  :',$tpr->end->strftime('%Y-%m-%d %H:%M:%S');
    note 'get  :',$rand_date->strftime('%Y-%m-%d %H:%M:%S');
    ok($rand_date >= Time::Piece->strptime('2012-01-01 00:00:00', '%Y-%m-%d %H:%M:%S'));
    ok($rand_date <= Time::Piece->strptime('2012-12-31 23:59:59', '%Y-%m-%d %H:%M:%S'));

};

subtest get_multi => sub {

    my $tpr =  Time::Piece::Random->new({
        start => '2012-01-01 00:00:00',
        end   => '2012-01-31 23:59:59'
    });
    note $tpr->start->strftime('%Y-%m-%d %H:%M:%S');
    note $tpr->end->strftime('%Y-%m-%d %H:%M:%S');
    my $start =Time::Piece->strptime('2012-01-01 00:00:00', '%Y-%m-%d %H:%M:%S');
    my $end   = Time::Piece->strptime('2012-01-31 23:59:59', '%Y-%m-%d %H:%M:%S');

    for my $rand_date ( $tpr->get_multi(10) ) {
        ok($rand_date >= $start );
        ok($rand_date <= $end );
    }

};


done_testing;
