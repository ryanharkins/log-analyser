#!/usr/bin/env ruby
require './lib/log_file_parser'
require './lib/aggregators/visits'

parser = LogFileParser.new(
  log_path: ARGV[0],
  format: '^(?<path>\S+)\s+(?<ip>\S+)',
  aggregator: Aggregators::Visits.new
)

result = parser.parse

def print_formatted(data, type)
  data.each do |line|
    puts "#{line[0]} #{line[1]} #{type}"
  end
end

def generate_graph(data, title)
  hash_response = Hash[data.map { |key, value| [key, value] }]
  UnicodePlot.barplot(data: hash_response, title: title).render
end

case ARGV[1]
  when '--with-graph'
    require 'unicode_plot'

    puts generate_graph(result.unique_visits, 'Unique visits')
    puts generate_graph(result.most_views, 'Most views')
  when '--with-table'
    require 'terminal-table'

    puts Terminal::Table.new headings: ['Path', 'Views'], rows: result.most_views, style: { width: 50 }
    puts " "
    puts Terminal::Table.new headings: ['Path', 'Unique visits'], rows: result.unique_visits, style: { width: 50 }
  else
    print_formatted(result.unique_visits, 'visits')
    puts '----'
    print_formatted(result.most_views, 'unique views')
  end
