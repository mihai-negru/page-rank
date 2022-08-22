function [page_rank_iter, page_rank_alg] = page_rank(filename, damp_fact, eps)
    % @brief Function to calculate the page rank starting from a
    % hyperlinks matrix. Function will calculate the page rank using
    % two methods, iterative and algebrical. Also the function will
    % generate an output file in the same directory as the function source
    % file. Function will print both algebrical and iterative page ranks
    % and will make a ranking for every page (the most and the least page
    % to show on searching engine), showing for every page its belonging
    % grade
    %
    % @param filename string object containing the name of the file
    % to read the hyperlinks matrix
    %
    % @param damp_fact floating point number storing the value of
    % the damping factor needed to calculate the page rank vector
    % usually the damping factor has the 0.85 value.
    %
    % @param eps a tolerance(error) to compute the page rank vector
    %
    % @return page_rank_iter a vector containing the iterative page ranks for every page
    %
    % @return page_rank_alg a vector containing the algebrical page ranks for every page

    % Compute the page rank vector using the iterative method
    page_rank_iter = page_rank_iterative(filename, damp_fact, eps);

    % Compute the page rank vector using the algebrical method
    page_rank_alg = page_rank_algebraic(filename, damp_fact);

    [~, outfilename] = fileparts(filename);

    outfilename = sprintf("%s.out", outfilename);

    % Open file for writing the answers
    [fout, err_msg] = fopen(outfilename, 'w');

    % Check if output file was opened successfully
    if fout == -1

        % Display the error message
        disp(err_msg);
    else

        % Find the number of the processed pages from hyperlinks matrix
        page_num = length(page_rank_iter);

        % Print in the out stream the number of processed pages
        fprintf(fout, "%d\n", page_num);
        
        % Print the page rank vector calculated using iterative method
        fprintf(fout, "%0.6f\n", page_rank_iter);
        fprintf(fout, "\n");

        % Print the page rank vector calculated using algebrical method
        fprintf(fout, "%0.6f\n", page_rank_alg);
        fprintf(fout, "\n");

        % Open filename to read param1 and param2
        % needed for the fuzzy function
        [fin, err_msg] = fopen(filename, 'r');

        % Check if the file was successfully opened
        if fin == -1

            % Display the error message
            disp(err_msg);
        else

            % Modify the file offset until hit param1
            for iter_i = 1 : page_num + 1
                [~] = fgetl(fin);
            end
            
            % Read param1 and param2 values
            param1 = str2double(fgetl(fin));
            param2 = str2double(fgetl(fin));
            
            % Close the file needed for the reading
            fclose(fin);

            % Ranking matrix
            page_rank = zeros(page_num, 3);

            % First col will be the page rank calculated
            % by algebrical method
            page_rank(:, 1) = page_rank_alg;

            % Second col will be the page number 
            page_rank(:, 2) = 1 : page_num;

            % Compute the belonging grade of every page
            for iter_i = 1 : page_num
                page_rank(iter_i, 3) = fuzzy_func(page_rank(iter_i, 1), param1, param2);
            end
    
            % Sort ranking matrix in descend order by their page ranks
            page_rank = sortrows(page_rank, 'descend');

            % Print in the out stream the ranking matrix 
            for iter_i = 1 : page_num
                fprintf(fout, "%d %d %0.6f\n", iter_i, page_rank(iter_i, 2), page_rank(iter_i, 3));
            end
    
            % Close the out stream file
            fclose(fout);
        end
    end
end