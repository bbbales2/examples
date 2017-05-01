data {
  int<lower=1> N;
  int<lower=1> K;
  int<lower=0> reuses[N];
  real strains[N];
}

parameters{
  real a;
  real b;
  real mu[K];
  real<lower=0.0> sig;
  real<lower=0.0> hsig;
}

model {
  for (k in 1:K)
    mu[k] ~ normal(a * (k - 1) + b, hsig);
  
  for (n in 1:N)
    strains[n] ~ normal(mu[reuses[n] + 1], sig);
}
