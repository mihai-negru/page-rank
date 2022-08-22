function [y] = fuzzy_func(page_rank, param1, param2)
    % @brief Fuzzy function to compute the belonging grade
    % of one page according to its rank value. The result is
    % calculated such that the fuzzy member function is a continuous
    % function that takes values from [0, 1].
    %
    % @param page_rank computed page rank of one individual
    % page from hyperlinks matrix
    %
    % @param param1 left limit param for the page rank
    %
    % @param param2 second limit param for the page rank
    %
    % @return y the result of the member fuzzy function

    % Compute the degree of belonging of a page
    if 0 <= page_rank && page_rank < param1
        y = 0;
    elseif param1 <= page_rank && page_rank <= param2
        y = page_rank ./ (param2 - param1) - param1 ./ (param2 - param1);
    elseif param2 < page_rank && page_rank <= 1
        y = 1;
    else

        % Wrong input for page rank value
        y = page_rank .* inf;
    end
end
	