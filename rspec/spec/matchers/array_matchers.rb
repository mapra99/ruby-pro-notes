module ArrayMatchers
  extend RSpec::Matchers::DSL

  matcher(:be_contiguous_by) do
    match do |array|
      non_contiguous_pairs(array).empty?
    end

    failure_message do |array|
      non_contiguous_pairs(array).map do |pair|
        "#{pair[0]} and #{pair[1]} were not contiguous"
      end.join(', ')
    end

    def non_contiguous_pairs(array)
      array
        .sort_by(&block_arg)
        .each_cons(2)
        .reject { |x, y| block_arg.call(x) + 1 == block_arg.call(y) }
    end
  end
end
