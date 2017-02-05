data {
    int<lower=0> P;                                // number of players
    int<lower=0> N_positions;                      // number of positions
    int<lower=1, upper=N_positions> positions[P];  // position for player

    int<lower=1, upper=P+1> start[N_positions+1];  // start index for each group of players
    int<lower=0> N[P];                             // number of attemps per player
    int<lower=0> y[P];                             // number of hits per player
    
    real<lower=0> A;
    real<lower=0> B;
    real<lower=0> S;
    real<lower=0> R;
}
parameters {
    real<lower=0, upper=1> omega0;
    vector<lower=0, upper=1>[N_positions] omega;  // group level hit rate
    real<lower=0> kappaMinusTwo0;
    vector<lower=0>[N_positions] kappaMinusTwo;
    real<lower=0, upper=1> theta[P];            // player level hit rate
} 
transformed parameters {
    real<lower=0> kappa0;
    real<lower=0> alpha0;
    real<lower=0> beta0;
    vector<lower=0>[N_positions] kappa;
    vector<lower=0>[N_positions] alpha;
    vector<lower=0>[N_positions] beta;

    kappa0 = kappaMinusTwo0 + 2;
    alpha0 = omega0 * (kappaMinusTwo0) + 1;
    beta0 = (1 - omega0) * (kappaMinusTwo0) + 1;

    kappa = kappaMinusTwo + 2;
    alpha = omega .* (kappaMinusTwo) + 1;
    beta = (1 - omega) .* (kappaMinusTwo) + 1;
}
model {
    omega0 ~ beta(A, B);
    kappaMinusTwo0 ~ gamma(S, R);
    
    omega ~ beta(alpha0, beta0);
    kappaMinusTwo ~ gamma(S, R);
    
    theta ~ beta(alpha[positions], beta[positions]);
    y ~ binomial(N, theta);
}
