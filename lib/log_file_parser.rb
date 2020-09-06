class LogFileParser
  def initialize(log_path:, format: , aggregator:)
    @file = File.open(log_path)
    @log_file_format = format
    @aggregator = aggregator
  end

  def parse
    @file.each do |line|
      parsed_line = parse_line(line)
      @aggregator.aggregate(parsed_line)
    end

    @aggregator
  end

  def parse_line(line)
    line.match(@log_file_format)
  end
end
