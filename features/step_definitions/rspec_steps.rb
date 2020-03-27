# frozen_string_literal: true

Then /^the example(?:s)? should(?: all)? pass$/ do
  step 'the output should contain "0 failures"'
  step 'the output should not contain "0 examples"'
  step 'the exit status should be 0'
end
