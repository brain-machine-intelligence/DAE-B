% choose action using softmax

function action = chooseAction(Q, state, softm)
    % Compute the action probabilities using softmax
    probabilities = exp(Q(state, :) / softm) / sum(exp(Q(state, :) / softm));
    % Randomly choose action based on the probabilities
    action = find(rand <= cumsum(probabilities), 1);
end