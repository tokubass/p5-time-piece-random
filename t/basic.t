use strict;
use warnings;
use Test::More;
use Time::Piece::Random;

my $FORMAT = '%Y-%m-%d %H:%M:%S';
#$ENV{TZ} = 'UTC';
subtest empty_input => sub {
    eval { Time::Piece::Random->new() };
    my $err = $@;
    ok( $err =~ /^please input start or end time at .*$/);

    eval { Time::Piece::Random->new() };
    my $err2 = $@;
    ok( $err2 =~ /^please input start or end time at .*$/);

};

subtest time_piece_object => sub {
    my $start = Time::Piece->strptime('2012-01-01 00:00:00', $FORMAT);
    my $end   = Time::Piece->strptime('2012-01-31 23:59:59', $FORMAT);
    
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
    note $tpr->start->strftime($FORMAT);
    note $tpr->end->strftime($FORMAT);

    my $rand_date = $tpr->get;

    ok($rand_date >= Time::Piece->strptime('2012-01-01 00:00:00', $FORMAT));
    ok($rand_date <= Time::Piece->strptime('2012-01-31 23:59:59', $FORMAT));

};

subtest only_date_range => sub {
    my $tpr = Time::Piece::Random->new({
        start => '2012-01-01',
        end   => '2012-01-31'
    });
    my $rand_date = $tpr->get;
    note 'start:',$tpr->start->strftime($FORMAT);
    note 'end:  ',$tpr->end->strftime($FORMAT);
    ok($rand_date >= Time::Piece->strptime('2012-01-01 00:00:00', $FORMAT));
    ok($rand_date <= Time::Piece->strptime('2012-01-31 23:59:59', $FORMAT));

};

subtest only_date_range_and_same_day => sub {
    my $tpr = Time::Piece::Random->new({
        start => '2012-01-01',
        end   => '2012-01-01'
    });
    my $rand_date = $tpr->get;
    note 'start:',$tpr->start->strftime($FORMAT);
    note 'end  :',$tpr->end->strftime($FORMAT);
    note 'get  :',$rand_date->strftime($FORMAT);
    
    my $start = Time::Piece->localtime->strptime('2012-01-01 00:00:00', $FORMAT);
    my $end   = Time::Piece->localtime->strptime('2012-01-01 23:59:59', $FORMAT);

    is($tpr->start->strftime($FORMAT) => $start->strftime($FORMAT), 'expected start time' );
    is($tpr->end  ->strftime($FORMAT) => $end  ->strftime($FORMAT), 'expected end time'   );

    ok($start->epoch < $rand_date->epoch && $rand_date->epoch < $end->epoch, 'start < rand < end');

    ok($rand_date->epoch > $start->epoch, 'rand > start');
    ok($rand_date->epoch < $end->epoch,   'rand < end');

};

subtest short_date_range => sub {
    my $tpr = Time::Piece::Random->new({
        start => '2012-01',
        end   => '2012-01'
    });
    my $rand_date = $tpr->get;
    note 'start:', $tpr->start->strftime($FORMAT);
    note 'end  :',$tpr->end->strftime($FORMAT);
    note 'get  :',$rand_date->strftime($FORMAT);

    ok($rand_date >= Time::Piece->strptime('2012-01-01 00:00:00', $FORMAT));
    ok($rand_date <= Time::Piece->strptime('2012-01-31 23:59:59', $FORMAT));

};

subtest more_short_date_range => sub {
    my $tpr = Time::Piece::Random->new({
        start => '2012',
        end   => '2012'
    });
    my $rand_date = $tpr->get;
    note 'start:', $tpr->start->strftime($FORMAT);
    note 'end  :',$tpr->end->strftime($FORMAT);
    note 'get  :',$rand_date->strftime($FORMAT);
    ok($rand_date >= Time::Piece->strptime('2012-01-01 00:00:00', $FORMAT));
    ok($rand_date <= Time::Piece->strptime('2012-12-31 23:59:59', $FORMAT));

};

subtest get_multi => sub {

    my $tpr =  Time::Piece::Random->new({
        start => '2012-01-01 00:00:00',
        end   => '2012-01-31 23:59:59'
    });
    note $tpr->start->strftime($FORMAT);
    note $tpr->end->strftime($FORMAT);
    my $start =Time::Piece->strptime('2012-01-01 00:00:00', $FORMAT);
    my $end   = Time::Piece->strptime('2012-01-31 23:59:59', $FORMAT);

    for my $rand_date ( $tpr->get_multi(4) ) {
        ok($rand_date >= $start );
        ok($rand_date <= $end );
    }

};


done_testing;
