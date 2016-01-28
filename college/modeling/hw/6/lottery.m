format long

n_tickets = 2000000
n_worth_0 = 1995499
n_worth_30 = 4000
n_worth_800 = 500
n_jackpot = 1

n_worth_0 + n_worth_30 + n_worth_800 + n_jackpot


function val = expected_value(n_tickets, n_worth_0, n_worth_30, n_worth_800, n_jackpot)
	val = 0.0;
	n_total = n_worth_0 + n_worth_30 + n_worth_800 + n_jackpot;
	printf('\nCalled expected_value for %d tickets\n', n_tickets)
	printf('n_worth_0: %d\n', n_worth_0)
	printf('n_worth_30: %d\n', n_worth_30)
	printf('n_worth_800: %d\n', n_worth_800)
	printf('n_jackpot: %d\n', n_jackpot)
	printf('n_total: %d\n\n', n_total)
	if n_tickets == 1
		val = (n_worth_30 * 30 + n_worth_800 * 800 + n_jackpot * 1200000)/n_total;
		printf('Expected Value of 1: %.15f\n\n', val);
	else
		gain_from_first_zero = expected_value(n_tickets-1, n_worth_0-1, n_worth_30, n_worth_800, n_jackpot);
		p_first_zero = n_worth_0 / n_total;
		printf('Expected value of rest given ticket %d is worth 0: %.15f\n', n_tickets, gain_from_first_zero);
		printf('Probability that ticket %d is worth 0: %.15f\n', n_tickets, p_first_zero);
		printf('Total Expected Value contributed for this case: %.15f\n', gain_from_first_zero * p_first_zero);
		val += gain_from_first_zero * p_first_zero;
		printf('Total Value so Far: %.15f\n', val)

		gain_from_first_30 = expected_value(n_tickets-1, n_worth_0, n_worth_30-1, n_worth_800, n_jackpot);
		p_first_30 = n_worth_30 / n_total;
		printf('Expected value of rest given ticket %d is worth 30: %.15f\n', n_tickets, gain_from_first_30);
		printf('Probability that ticket %d is worth 30: %.15f\n', n_tickets, p_first_30);
		printf('Total Expected Value contributed for this case: %.15f\n', ( 30 + gain_from_first_30 ) * p_first_30);
		val += (30 + gain_from_first_30) * p_first_30;
		printf('Total Value so Far: %.15f\n', val)

		gain_from_first_800 = expected_value(n_tickets-1, n_worth_0, n_worth_30, n_worth_800-1, n_jackpot);
		p_first_800 = n_worth_800 / n_total;
		printf('Expected value of rest given ticket %d is worth 800: %.15f\n', n_tickets, gain_from_first_800);
		printf('Probability that ticket %d is worth 800: %.15f\n', n_tickets, p_first_800);
		printf('Total Expected Value contributed for this case: %.15f\n', ( 800 + gain_from_first_800) * p_first_800);
		val += ( 800 + gain_from_first_800) * p_first_800;
		printf('Total Value so Far: %.15f\n', val)

		if n_jackpot >= 1
			gain_from_first_jackpot = expected_value(n_tickets-1, n_worth_0, n_worth_30, n_worth_800, n_jackpot-1);
			p_first_jackpot = n_jackpot / n_total;
			printf('Expected value of rest given ticket %d is jackpot: %.15f\n', n_tickets, gain_from_first_jackpot);
			printf('Probability that ticket %d is jackpot: %.15f\n', n_tickets, p_first_jackpot);
			printf('Total Expected Value contributed for this case: %.15f\n', ( 1200000 + gain_from_first_jackpot) * p_first_jackpot);
			val += ( 1200000 + gain_from_first_800) * p_first_jackpot;
			printf('Total Value so Far: %.15f\n', val)
		end
	end
end

%twice_ev = 2 * expected_value(1, n_worth_0, n_worth_30, n_worth_800, n_jackpot);
ev_twice = expected_value(2, n_worth_0, n_worth_30, n_worth_800, n_jackpot);
%printf('%.15f\n%.15f', twice_ev, ev_twice)
