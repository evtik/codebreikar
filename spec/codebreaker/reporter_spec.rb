require 'spec_helper'

module Codebreaker
  describe Reporter do
    context '#render_line' do
      it "renders a line of '-'`s" do
        expect(subject.render_line).to match(/\A-+/)
      end
    end

    context '#render_title' do
      it 'renders a game title with code' do
        expect(subject.render_title('3344')).to match(/\sresults\s.+\s3344\s/)
      end
    end

    context '#render_headers' do
      it 'renders report headers' do
        expect(subject.render_headers)
          .to match(/attempt\s.+guess\s.+feedback/i)
      end
    end

    context '#render_guesses' do
      it 'renders guesess array' do
        count = rand(1..10)
        guesses = Array.new(count) { ['4321', '----'] }
        lines = subject.render_guesses(guesses).split("\n")
        lines[0..count - 1].each do |l|
          expect(l).to match(/\s+\d{1,2}\s+[1-6]{4}\s+[+-]{0,4}\z/)
        end
      end
    end

    context '#render_footer' do
      it 'renders winner footer' do
        guess = ['1234', '++++']
        expect(subject.render_footer(guess)).to match(/you won/i)
      end

      it 'renders looser footer' do
        guess = ['1234', '--']
        expect(subject.render_footer(guess)).to match(/you lost/i)
      end
    end
  end
end
