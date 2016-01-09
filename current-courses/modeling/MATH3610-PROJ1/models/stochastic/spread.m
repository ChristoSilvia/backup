function [peak, hosps, sick_per_delta, hospitalized] = spread(age_range, p)
  if nargin == 1
    p = false;
  end

  global ithaca_pop;
  global vaccines;
  global init_sick;
  global num_juniors;
  global num_adults;
  global num_seniors;
  global junior_center;
  global adult_center;
  global senior_center;

  ithaca_pop = 60000;
  vaccines = 4000/4; % Vaccines per week

  ithaca_pop = ithaca_pop;
  vaccines = vaccines;

  init_sick = ithaca_pop/20;

  % Census data for age ranges
  num_juniors   = 0.6*ithaca_pop;
  num_adults    = 0.3*ithaca_pop;
  num_seniors   = 0.1*ithaca_pop;

  junior_center   = num_juniors/2;
  adult_center    = num_juniors + num_adults/2;
  senior_center   = num_juniors + num_adults + num_seniors/2;

  heal_chance = 0.9;
  age = zeros(1, ithaca_pop);
  sick = zeros(1, ithaca_pop);
  hospitalized = zeros(1, ithaca_pop);
  vaccinated = zeros(1, ithaca_pop);

  function v = ifelse(c, t, f)
    if c
      v = t;
    else
      v = f;
    end
  end

  function conn = connectivity(age)
    switch age
      case 1
        conn = 25;
      case 2
        conn = 15;
      case 3
        conn = 5;
    end
  end

  function comp = comp_chance(age)
    switch age
      case 1
        comp = 0.05;
      case 2
        comp = 0.2;
      case 3
        comp = 0.75;
    end
    % comp = 0.95;
  end

  for i = 1:ithaca_pop
    if i <= num_juniors
      age(i) = 1;
    elseif i <= (num_juniors + num_adults)
      age(i) = 2;
    else
      age(i) = 3;
    end
  end

  weeks = 8; % 2 months
  sick_per_delta = zeros(1 + weeks, 4);

  for c = round(rand(1,init_sick)*(ithaca_pop - 1)) + 1
    sick(c) = true;
    sick_per_delta(1, age(c) + 1) = sick_per_delta(1, age(c) + 1) + 1;
  end

  n = 1;
  for w = 1:weeks
    disp(sprintf('Week: %d', w));
    vax = 0;
    % for k = ifelse(age_range == 1, 1:ithaca_pop, ithaca_pop:-1:1)
    %   if ~vaccinated(k)
    %     vaccinated(k) = true;
    %     vax = vax + 1;
    %   end
    %   if vax == vaccines
    %     break
    %   end
    % end
    while vax ~= vaccines
      r = round(rand*(ithaca_pop-1))+1;
      if ~vaccinated(r)
        vaccinated(r) = true;
        vax = vax + 1;
      end
    end
    for c = 1:ithaca_pop
      if sick(c)
        if (rand < heal_chance)
          sick(c) = false;
          vaccinated(c) = true;
        elseif (rand < comp_chance(age(c)))
          sick(c) = false;
          hospitalized(c) = true;
        else
          for r = random_vaccine(age(c), connectivity(age(c)))
            if (~vaccinated(r) && ~sick(r))
              sick(r) = (sick(r) || rand < 0.8);
            end
          end
        end
      end
    end
    n = n+1;
    stats = zeros(1, 4);
    for c = 1:ithaca_pop
      if sick(c)
        stats(age(c) + 1) = stats(age(c) + 1) + 1;
      elseif hospitalized(c)
        stats(1) = stats(1) + 1;
      end
    end
    sick_per_delta(n,:) = stats;
  end

  peak = round(max(sum(sick_per_delta'))/ithaca_pop,4)*100;
  hosps = sick_per_delta(size(sick_per_delta,1), 1);

  close all;

  if p
    f = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
    hBar = bar(0:weeks, sick_per_delta, 'stacked');
    colormap([0 0 0; 1 0 0; 0 1 0; 1 1 0]);
    legend('Hospitalized', 'Juniors', 'Adults', 'Seniors');
    title(sprintf('Weekly spread of flu, %d initally infected. Total hospitalizations: %d\nPeak infection rate: %.2f', init_sick, hosps, peak));
    xlabel('Weeks');
    ylabel('Infections');
    xlim([0 weeks]);
    saveas(f, 'Weekly sick', 'png');
  end

  disp(sprintf('Peak infection rate: %.2f', peak));
  disp(sprintf('Total hospitalizations: %d', hosps));
end