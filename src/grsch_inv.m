function [inv_mat] = grsch_inv(mat)
    % @brief Function to calculate the inverse matrix of a square matrix
    % using Gram-Schmidt algorithm considering Q an orthogonal
    % matrix and R a superior triungular matrix. After that we will
    % solve "input_mat_dim" linear superior triungular systems of
    % equations.
    %
    % @param mat the square matrix to inverse
    %
    % @return inv_mat the sqare matrix inversed
    
    % Find the input square matrix dimensions
    [mat_dim, ~] = size(mat);

    % Initialize R and Q matrix for the gram-schmidt algorithm
    r_gram = zeros(mat_dim);
    q_gram = zeros(mat_dim);

    % Gram-Schmidt algorithm
    for iter_i = 1 : mat_dim
        r_gram(iter_i, iter_i) = norm(mat(:, iter_i),2);
        q_gram(:, iter_i) = mat(:, iter_i) ./ r_gram(iter_i, iter_i);

        for iter_j = iter_i + 1 : mat_dim
            r_gram(iter_i, iter_j) = (q_gram(:, iter_i)') * mat(:, iter_j);
            mat(:, iter_j) = mat(:, iter_j) - q_gram(:, iter_i) * r_gram(iter_i, iter_j);
        end
    end
    
    % Initialize the inverse square matrix
    inv_mat = zeros(mat_dim);

    % Solve a liniar superior triungular
    % system for "mat_dim" times
    for iter_i = mat_dim : -1 : 1
        mat_sum = zeros(mat_dim, 1);
        for iter_j = iter_i + 1 : mat_dim
            mat_sum = mat_sum + r_gram(iter_i, iter_j) * inv_mat(:, iter_j);
        end
        
        % Update the inverse matrix column
        inv_mat(:, iter_i) = (q_gram(:, iter_i) - mat_sum) ./ r_gram(iter_i, iter_i);
    end
    
    % Transpose the result matrix to get the inverse matrix
    inv_mat = inv_mat';
end