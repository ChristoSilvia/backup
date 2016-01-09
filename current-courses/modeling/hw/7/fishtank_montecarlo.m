% set parameters:
nsim = 100;
nweeks = 104;
ndays = 7*nweeks;
a = 1/7;

% number of different simulations to do
% number of weeks in each simulation
% number of days in each simulation
% probability of a customer each day
days_for_delivery = 5;
order_when_out = 1; % days from order to delivery of new tanks
% = 1 ==> order a new tank when stock==0
% = 0 ==> don’t order when out of tanks
fixed_delivery = 12;

% profits and losses:
saleprofit = 20;
lostloss = 10;
overstockloss = .50;
% initialize:
profit = zeros(nsim,1);
% print column headings:
==>
standing order for a new tank
every so many days
% profit from selling one tank
% loss from losing a customer
% cost of each tank overstock per night42
disp(’customers
sold
lost
fraction_served
overstock
end_stock
profit’)
for sim=1:nsim
% initialize:
random_nums = rand(ndays,1);
% array of random numbers to use each day
total_cust = 0;
total_sold = 0;
total_lost = 0;
stock = 1;
% number of tanks in stock
deliv = -1; % number of days until delivery of tank on order
% -1 means none on order
overstock = 0; % increment every night by number of excess tanks in stock
% main loop for a single simulation:
day = 0;
for week = 1:nweeks
for weekday = 1:7
day = day+1;
% day in the simulation
sold = 0;
lost = 0;
if deliv == 0
stock = stock+1;
% a new tank is delivered
% at the beginning of the day
end
if deliv >= 0
deliv = deliv-1;
% days till next delivery
end
if (mod(7*week + day, fixed_delivery) == 0)
% A new tank is delivered every so many days regardless of stock
stock = stock+1;
end
% use random number to decide how many customers arrived
% Here assume 0 or 1:
if random_nums(day) < a
customers = 1;
else
customers = 0;
end
if customers==1
if stock>0
sold = sold+1;
stock = stock-1;
else
lost = lost+1;
end
end
% we have a tank to sell the customer
% we didn’t have a tank and lost a customer
if (order_when_out & stock==0 & deliv < 0)4.6 Poisson processes
43
% none in stock and none on order
deliv = days_for_delivery; % order another
end
if stock > 1
overstock = overstock + (stock - 1);
end
% keep track of total statistics:
total_cust = total_cust + customers;
total_sold = total_sold + sold;
total_lost = total_lost + lost;
stock_record(day) = stock; % keep track of stock on each day
end % loop on day
end % loop on week
fraction_served = total_sold / total_cust;
profit(sim) = total_sold*saleprofit ...
- total_lost*lostloss - overstock*overstockloss;
% output total statistics:
disp(sprintf(’%6.0f %6.0f %8.0f %12.3f %11.0f %8.0f %12.2f’, ...
total_cust, total_sold, total_lost, fraction_served, overstock, stock, ...
profit(sim)))
end % loop on sim
% compute and print average profit over all simulations:
average_profit = sum(profit) / nsim
disp(’ ’)
disp([’ average profit
= ’ sprintf(’%10.2f’, average_profit)])
% standard deviation:
variance = sum((profit - average_profit).^2) / (nsim-1);
standard_deviation = sqrt(variance);
disp([’ standard deviation = ’ sprintf(’%10.2f’, standard_deviation)])
disp(’ ’)
% plot histogram of profits over all simulations:
hist(profit,-1500:50:2000)
axis([-1500 2000 0 30])
