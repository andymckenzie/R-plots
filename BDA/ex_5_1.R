#example 5.1 from DBDA 
prior = 0.019 #using the prior as the posterior from one positive result, given a prior of 0.001 
test_neg_if_pos = 1 - 0.99 #if disease positive 
test_neg_if_neg = 0.99 #if disease negative

posterior = (test_neg_if_pos * prior)/
  ((test_neg_if_pos * prior) + (test_neg_if_neg * prior))
  
