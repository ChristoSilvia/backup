function people = random_vaccine(age, len)
  global ithaca_pop;
  global vaccines;
  global init_sick;
  global num_juniors;
  global num_adults;
  global num_seniors;
  global junior_center;
  global adult_center;
  global senior_center;

  num_people = [num_juniors, num_adults, num_seniors];
  offset = [0, num_juniors, num_juniors + num_adults];

  if nargin == 1
    if rand < 0.75
      people = round(rand*(num_people(age)-1)) + 1 + offset(age);
    elseif rand < 0.5
      people = round(rand*(num_people(mod(age + 1, 3) + 1)-1)) + 1 + offset(mod(age + 1, 3) + 1);
    else
      people = round(rand*(num_people(mod(age + 2, 3) + 1)-1)) + 1 + offset(mod(age + 2, 3) + 1);
    end
  else
    switch age
      case 1
        ppl = round(raylrnd(junior_center, 1, len));
      case 2
        ppl = round(normrnd(adult_center, num_adults, 1, len));
      case 3
        ppl = round(ithaca_pop - raylrnd(senior_center, 1, len));
    end
    ppl(ppl < 1) = 1;
    ppl(ppl > ithaca_pop) = ithaca_pop;
    people = ppl;
  end
end