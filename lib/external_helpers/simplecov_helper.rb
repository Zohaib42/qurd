# frozen_string_literal: true

# spec/simplecov_helper.rb
require 'active_support/inflector'
require 'simplecov'

class SimpleCovHelper
  def self.report_coverage(base_dir: './coverage_results')
    SimpleCov.start 'rails' do
      skip_check_coverage = ENV['CIRCLE_JOB'] == 'test'

      # Add filters to exclude coverage reports of certain directories
      add_filter 'vendor/'
      add_filter 'lib/external_helpers/'

      Dir['app/*'].each do |dir|
        add_group File.basename(dir).humanize, dir
      end

      minimum_coverage(100) unless skip_check_coverage
      merge_timeout(3600)
    end
    new(base_dir: base_dir).merge_results
  end

  attr_reader :base_dir

  def initialize(base_dir:)
    @base_dir = base_dir
  end

  def all_results
    Dir["#{base_dir}/.resultset*.json"]
  end

  def merge_results
    results = all_results.map { |file| SimpleCov::Result.from_hash(JSON.parse(File.read(file))) }
    merged_result = SimpleCov::ResultMerger.merge_results(*results).tap do |result|
      SimpleCov::ResultMerger.store_result(result)
    end

    generate_error_report(merged_result)
  end

  def generate_error_report(merged_result)
    SimpleCov.at_exit do
      @exit_status = if $ERROR_INFO # was an exception thrown?
                       # if it was a SystemExit, use the accompanying status
                       # otherwise set a non-zero status representing termination by
                       # some other exception (see github issue 41)
                       $ERROR_INFO.is_a?(SystemExit) ? $ERROR_INFO.status : SimpleCov::ExitCodes::EXCEPTION
                     else
                       # Store the exit status of the test run since it goes away
                       # after calling the at_exit proc...
                       SimpleCov::ExitCodes::SUCCESS
                     end
      # Check the covered_percentages from the merged result
      covered_percent = merged_result.covered_percent.round(2)

      # No other error thrown
      if @exit_status == SimpleCov::ExitCodes::SUCCESS && covered_percent < SimpleCov.minimum_coverage
        $stderr.printf("Coverage (%.2f%%) is below the expected minimum coverage (%.2f%%).\n", covered_percent, SimpleCov.minimum_coverage)
        @exit_status = SimpleCov::ExitCodes::MINIMUM_COVERAGE
      end

      # Force exit with stored status (see github issue #5)
      # unless it's nil or 0 (see github issue #281)
      merged_result.format!

      Kernel.exit @exit_status if @exit_status&.positive?
    end
  end
end
