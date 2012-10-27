use strict;
use warnings;
use Test::More;
use Time::Piece::Random;

my $FORMAT = '%Y-%m-%d %H:%M:%S';

subtest empty_input => sub {

    eval { Time::Piece::Random->new() };
    my $err = $@;
    ok( $err =~ /^please input start or end time at .*$/);

    eval { Time::Piece::Random->new() };
    my $err2 = $@;
    ok( $err2 =~ /^please input start or end time at .*$/);

};

subtest time_piece_object => sub {

    my $start = Time::Piece->localtime->strptime('2012-01-01 00:00:00', $FORMAT);
    my $end   = Time::Piece->localtime->strptime('2012-01-31 23:59:59', $FORMAT);
    
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
    my $rand_date = $tpr->get;

    ok($rand_date >= Time::Piece->localtime->strptime('2012-01-01 00:00:00', $FORMAT));
    ok($rand_date <= Time::Piece->localtime->strptime('2012-01-31 23:59:59', $FORMAT));

};

subtest only_date_range => sub {
    my $tpr = Time::Piece::Random->new({
        start => '2012-01-01',
        end   => '2012-01-31'
    });
    my $rand_date = $tpr->get;

    ok($rand_date >= Time::Piece->localtime->strptime('2012-01-01 00:00:00', $FORMAT));
    ok($rand_date <= Time::Piece->localtime->strptime('2012-01-31 23:59:59', $FORMAT));

};

subtest only_date_range_and_same_day => sub {
    my $tpr = Time::Piece::Random->new({
        start => '2012-01-01',
        end   => '2012-01-01'
    });
    my $rand_date = $tpr->get;
    
    my $start = Time::Piece->localtime->strptime('2012-01-01 00:00:00', $FORMAT);
    my $end   = Time::Piece->localtime->strptime('2012-01-01 23:59:59', $FORMAT);

    is($tpr->start->strftime($FORMAT) => $start->strftime($FORMAT), 'expected start time' );
    is($tpr->end  ->strftime($FORMAT) => $end  ->strftime($FORMAT), 'expected end time'   );

    ok($start->epoch < $rand_date->epoch && $rand_date->epoch < $end->epoch, 'start < rand < end');

    ok($rand_date->epoch > $start->epoch, 'rand > start');
    ok($rand_date->epoch < $end->epoch,   'rand < end');

};

subtest only_year_and_month => sub {
    my $tpr = Time::Piece::Random->new({
        start => '2012-01',
        end   => '2012-01'
    });
    my $rand_date = $tpr->get;

    ok($rand_date >= Time::Piece->localtime->strptime('2012-01-01 00:00:00', $FORMAT));
    ok($rand_date <= Time::Piece->localtime->strptime('2012-01-31 23:59:59', $FORMAT));

};

subtest only_year => sub {
    my $tpr = Time::Piece::Random->new({
        start => '2012',
        end   => '2012'
    });
    my $rand_date = $tpr->get;

    ok($rand_date >= Time::Piece->localtime->strptime('2012-01-01 00:00:00', $FORMAT));
    ok($rand_date <= Time::Piece->localtime->strptime('2012-12-31 23:59:59', $FORMAT));

};

subtest scalar_arg => sub {
    my $tpr = Time::Piece::Random->new('2012-01-01');
    my $rand_date = $tpr->get;
    my $start = Time::Piece->localtime->strptime('2012-01-01 00:00:00', $FORMAT);
    my $end   = Time::Piece->localtime->strptime('2012-01-01 23:59:59', $FORMAT);

    ok($rand_date >= $start) or diag ($rand_date->strftime($FORMAT) ,' >= ', $start->strftime($FORMAT) );
    ok($rand_date <= $end  ) or diag ($rand_date->strftime($FORMAT) ,' <= ', $end  ->strftime($FORMAT));

};

subtest scalar_arg_and_only_year_and_month => sub {
    my $tpr = Time::Piece::Random->new('2012-01');
    my $rand_date = $tpr->get;
    my $start = Time::Piece->localtime->strptime('2012-01-01 00:00:00', $FORMAT);
    my $end   = Time::Piece->localtime->strptime('2012-01-31 23:59:59', $FORMAT);

    ok($rand_date >= $start) or diag ($rand_date->strftime($FORMAT) ,' >= ', $start->strftime($FORMAT) );
    ok($rand_date <= $end  ) or diag ($rand_date->strftime($FORMAT) ,' <= ', $end  ->strftime($FORMAT));

};

subtest scalar_arg_and_only_year => sub {
    my $tpr = Time::Piece::Random->new('2012');
    my $rand_date = $tpr->get;
    my $start = Time::Piece->localtime->strptime('2012-01-01 00:00:00', $FORMAT);
    my $end   = Time::Piece->localtime->strptime('2012-12-31 23:59:59', $FORMAT);

    ok($rand_date >= $start) or diag ($rand_date->strftime($FORMAT) ,' >= ', $start->strftime($FORMAT) );
    ok($rand_date <= $end  ) or diag ($rand_date->strftime($FORMAT) ,' <= ', $end  ->strftime($FORMAT));

};

subtest get_multi => sub {

    my $tpr =  Time::Piece::Random->new({
        start => '2012-01-01 00:00:00',
        end   => '2012-01-31 23:59:59'
    });

    my $start = Time::Piece->localtime->strptime('2012-01-01 00:00:00', $FORMAT);
    my $end   = Time::Piece->localtime->strptime('2012-01-31 23:59:59', $FORMAT);

    for my $rand_date ( $tpr->get_multi(4) ) {
        ok($rand_date >= $start) or diag ($rand_date->strftime($FORMAT) ,' >= ', $start->strftime($FORMAT) );
        ok($rand_date <= $end  ) or diag ($rand_date->strftime($FORMAT) ,' <= ', $end  ->strftime($FORMAT));
    }

};


done_testing;
