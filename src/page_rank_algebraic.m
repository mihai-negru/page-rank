function [page_rank] = page_rank_algebraic(filename, damp_fact)
    % @brief Function to calculate the page rank starting from a
    % hyperlinks matrix. The algorithm is a non-iterative one.
    % using Matrix inversations "grschm_inv" and a page grade matrix
    % we are able to calculate the exact form of the page rank vector
    %
    % @param filename string object containing the name of the file
    % to read the hyperlinks matrix
    %
    % @param damp_fact floating point number storing the value of
    % the damping factor needed to calculate the page rank vector
    % usually the damping factor has the 0.85 value.
    %
    % @return page_rank a vector containing the page ranks for every page
    
    % Open filename for reading information
    [fin, err_msg] = fopen(filename, "r");

    % Check if the file was opened successfully
    if fin == -1

        % Display error message
        disp(err_msg);
    else

        % Set number format to long
        format long

        % Read the dimension of the hyperlink matrix 
        mat_dim = fscanf(fin, "%d", 1);

        % Create the hyperlink matrix
        hyper_links = zeros(mat_dim);

        % Read the hyperlinks matrix from the file
        for iter_i = 1 : mat_dim
            
            % Read the parent page
            page = fscanf(fin, "%d", 1);

            % Read the number of hyperlinks
            links_num = fscanf(fin, "%d", 1);

            % Read all hyperlinks
            links = fscanf(fin, "%d", links_num);
            
            % Update hyperlink matrix
            for iter_j = 1 : links_num
                
                % If a page has a hyperlink to itself, ignore it
                if page ~= links(iter_j)
                    hyper_links(page, links(iter_j)) = 1;
                end
            end
        end

        % Close the file, no more reading needed
        fclose(fin);
        
        % Compute the number of hyperlinks for
        % every page
        page_links = sum(hyper_links, 2);

        % Create page hyperlink grade matrix
        page_grades = zeros(mat_dim);

        % Compute the page grade matrix
        for iter_i = 1 : mat_dim
            page_grades(iter_i, iter_i) = 1 ./ page_links(iter_i);
        end

        % Compute the new hyperlinks matrix, including the damping factor
        hyper_links = eye(mat_dim) - damp_fact .* (page_grades * hyper_links)';

        % Compute the page rank vector
        page_rank = grsch_inv(hyper_links) * (((1 - damp_fact) ./ mat_dim) .* ones(mat_dim, 1)); 
    end
end