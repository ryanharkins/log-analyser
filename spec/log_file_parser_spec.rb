require 'log_file_parser'

class FakeAggregator
  def aggregate _; end
end

describe LogFileParser do
  let(:log_file_path) { 'spec/fixtures/webserver.log' }
  let(:aggregator) { FakeAggregator.new }

  describe '#initialize' do
    context "missing params" do
      it "raises a Runtime Error" do
        expect{
          described_class.new(log_path: log_file_path)
        }.to raise_error(ArgumentError)
      end
    end

    context 'correct params passed' do
      subject do
        described_class.new(
          log_path: log_file_path,
          format: '^(?<path>\S+)\s+(?<ip>\S+)',
          aggregator: aggregator
        )
      end

      describe '#parse_line' do
        it "matches the data" do
          result = subject.parse_line('/home 0.0.0.0')

          expect(result[:ip]).to eq '0.0.0.0'
          expect(result[:path]).to eq '/home'
        end
      end

      describe 'parse' do
        it 'returns an instance of the aggregator' do
          expect(subject.parse).to be_kind_of(FakeAggregator)
        end

        it 'calls aggregate on the aggregator class' do
          expect(aggregator).to receive(:aggregate).exactly(3).times
          subject.parse
        end
      end
    end
  end
end
