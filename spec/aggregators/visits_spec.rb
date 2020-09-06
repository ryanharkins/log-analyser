require 'aggregators/visits'

describe Aggregators::Visits do
  subject { described_class.new }

  describe '#initialize' do
    it "starts with empty most_views and unique_visits" do
      expect(subject.most_views).to eq []
      expect(subject.unique_visits).to eq []
    end
  end

  describe '#aggregate' do
    it 'adds entries for most_views' do
      subject.aggregate({ ip:'0.0.0.0', path: '/home' })
      subject.aggregate({ ip:'0.0.0.1', path: '/home' })
      subject.aggregate({ ip:'0.0.0.1', path: '/about/2' })

      expect(subject.most_views).to eq [["/home", 2], ["/about/2", 1]]
    end

    it 'adds entries for unique_visits' do
      subject.aggregate({ ip:'0.0.0.0', path: '/home' })
      subject.aggregate({ ip:'0.0.0.1', path: '/home' })
      subject.aggregate({ ip:'0.0.0.1', path: '/about/2' })

      expect(subject.unique_visits).to eq [['/home', 2], ['/about/2', 1]]
    end
  end
end
