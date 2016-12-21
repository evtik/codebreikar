require 'spec_helper'

module Codebreaker
  describe Saver do
    context '#save_game' do
      around(:example) do |example|
        @filename = 'breaker'
        @filepath = File.join(APP_ROOT, @filename + '.txt')
        @content = 'test content'
        example.run
        File.delete(@filepath)
      end

      it 'shows file saved message' do
        expect { subject.save_game(@filename, @content) }
          .to output(/file #{@filename}.txt saved/i).to_stdout
      end

      it 'ensures file is saved to fs' do
        subject.save_game(@filename, @content)
        expect(File.exist?(@filepath)).to be(true)
      end

      it 'ensures file has expected content' do
        subject.save_game(@filename, @content)
        expect(File.read(@filepath)).to eq(@content)
      end
    end
  end
end
