module Aggregators
  class Visits
    def initialize
      @most_visits = Hash.new(0)
      @unique_visits = Hash.new { |h, k| h[k] = Set.new }
    end

    def aggregate(data)
      @most_visits[data[:path]] += 1
      @unique_visits[data[:path]].add(data[:ip])
    end

    def most_views
      @most_visits.sort_by { |k, v| -v }
    end

    def unique_visits
      @unique_visits.map{ |page, ips| [page, ips.length] }.sort_by { |k, v| -v }
    end
  end
end
