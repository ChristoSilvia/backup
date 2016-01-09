% set parameters
global nsim = 2000;
global nweeks = 104;
global ndays = 7*nweeks;

global a = 1/7; % possibility of a customer each day

global days_for_delivery = 5;
global order_when_out = 0; % order a new tank when stock is zero if this is 1

global saleprofit = 20;
global lostloss = 10;
global overstockloss = 0.5;

profit = zeros(nsim, 1);

printf('customers  sold      lost  fraction_served    ovrstock  end_stock   profit\n');

function [average_profit, standard_deviation] = profit_for_delivery_schedule(fixed_delivery, max_stockpile)
	global nsim; global nweeks; global ndays; global a;
	global days_for_delivery; global order_when_out;
	global saleprofit; global lostloss; global overstockloss;
	for sim = 1:nsim
		random_nums = rand(ndays,1);
		total_cust = 0;
		total_sold = 0;
		total_lost = 0;
		stock = 1;
		deliv = -1; % days until delivery of tank on order. -1 means none on order.
		overstock = 0;
	
		for week = 1:nweeks
			for weekday = 1:7
				day = 7*(week-1) + weekday;
				sold = 0;
				lost = 0;
				if deliv == 0
					stock = stock + 1;
				elseif deliv >= 0
					deliv = deliv - 1;
				end
	
				if ((mod(day, fixed_delivery) == 0) && stock <= max_stockpile)
					stock = stock + 1;
				end
				if stock == max_stockpile
					printf('Stockpile Full\n')
				end
	
				if random_nums(day) < a
					customers = 1;
				else
					customers = 0;
				end
	
				if customers == 1
					if stock > 0
						sold = sold + 1;
						stock = stock-1;
					else
						lost = lost + 1;
					end
				end
	
				if (order_when_out && stock==0 && deliv < 0)
					deliv = days_for_delivery;
				end
	
				if stock > 1
					overstock = overstock + (stock - 1);
				end
	
				total_cust = total_cust + customers;
				total_sold = total_sold + sold;
				total_lost = total_lost + lost;
				stock_record(day) = stock;
			end
		end
	
		fraction_served = total_sold/total_cust;
		profit(sim) = total_sold*saleprofit - total_lost*lostloss - overstock*overstockloss;
		printf('%6.0f  %6.0f  %8.0f %12.3f  %11.0f  %8.0f  %12.2f\n',
			total_cust, total_sold, total_lost, fraction_served, overstock, stock,
			profit(sim))
	end
	average_profit = sum(profit) / nsim;
	variance = sum((profit - average_profit).^2)/(nsim-1);
	standard_deviation = sqrt(variance);
	title(sprintf('Profits for M=%d, i=%d, order_when_out=%d',max_stockpile, fixed_delivery, order_when_out))
	hist(profit,35,'facecolor','black')
	xlabel('profit')
	print(sprintf('historgram-%d-%d-%d.png',max_stockpile,fixed_delivery,order_when_out))
end

pareto_front = load('pareto-front-2.csv')
for i = 1:length(pareto_front(:,1))
	[expected_profit, expected_stdiv] =  profit_for_delivery_schedule(pareto_front(i,3),pareto_front(i,2))
end

