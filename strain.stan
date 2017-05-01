data {
  int<lower=1> N;
  int<lower=1> K;
  int<lower=0> reuses[N];
  real strains[N];
}

parameters{
  real a;
  real b;
  real<lower=0.0> sig;
}

model {
  for (n in 1:N)
    strains[n] ~ normal(a * reuses[n] + b, sig);
}

generated quantities {
  real sthat[K];
  
  for (k in 1:K)
    sthat[k] = normal_rng(a * (k - 1) + b, sig);
}