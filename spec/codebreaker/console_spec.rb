require 'spec_helper'

module Codebreaker
  describe Console do
    context '#init_game' do
      before(:example) do
        subject.init_game
      end

      it 'shows new game message' do
        expect { subject.init_game }.to output(/new game/i).to_stdout
      end

      it 'creates a new Game object' do
        expect(subject.game).not_to be_nil
      end

      it 'initializes @attempts equal to ATTEMPTS value' do
        attempts = described_class.const_get(:ATTEMPTS)
        expect(subject.instance_variable_get(:@attempts)).to eq(attempts)
      end

      it 'initializes @game_over to false' do
        expect(subject.instance_variable_get(:@game_over)).to be(false)
      end

      it 'initializes @guesses to an empty array' do
        expect(subject.guesses).to be_an(Array)
        expect(subject.guesses.length).to be_zero
      end

      it 'initializes @report to nil' do
        expect(subject.instance_variable_get(:@report)).to be_nil
      end
    end

    context '#parse_user_command' do
      it 'shows user prompt' do
        allow(subject).to receive(:gets).and_return('q')
        expect { subject.parse_user_command }.to output(/enter/i).to_stdout
      end

      context 'with valid input' do
        it "shows game hint when gets 'h'" do
          allow(subject).to receive(:gets).and_return('h')
          expect(subject.parse_user_command).to eq(:show_hint)
        end

        it "quits the game when gets 'q'" do
          allow(subject).to receive(:gets).and_return('q')
          expect(subject.parse_user_command).to eq(:quit_game)
        end

        it 'submits a guess when gets a 4-digit number' do
          allow(subject).to receive(:gets).and_return('1234')
          result = subject.parse_user_command
          expect(result).to be_an(Array)
          expect(result[0]).to eq(:submit_input)
          expect(result[1]).to eq('1234')
        end
      end

      context 'with invalid input' do
        it 'marks input as invalid when gets unknown command' do
          allow(subject).to receive(:gets).and_return('qwerty')
          expect(subject.parse_user_command).to eq(:invalid_input)
        end

        it 'marks input as invalid when gets less than 4 digits' do
          allow(subject).to receive(:gets).and_return('21')
          expect(subject.parse_user_command).to eq(:invalid_input)
        end

        it 'marks input as invalid when gets more than 4 digits' do
          allow(subject).to receive(:gets).and_return('123456')
          expect(subject.parse_user_command).to eq(:invalid_input)
        end
      end
    end

    context '#invalid_input' do
      it 'shows invalid input message' do
        expect { subject.invalid_input }.to output(/invalid/i).to_stdout
      end
    end

    context '#submit_input' do
      shared_examples_for '@guesses incrementer' do
        it 'increments @guesses by 1' do
          expect { subject.submit_input('4321') }
            .to change { subject.guesses.length }.by(1)
        end
      end
      context 'with guess equal to @game.code' do
        before(:example) do
          game = double('Game', code: '4321')
          subject.instance_variable_set(:@game, game)
          subject.instance_variable_set(:@guesses, [])
        end

        it_behaves_like '@guesses incrementer'

        it "adds '++++' to @guesses array" do
          subject.submit_input('4321')
          expect(subject.guesses.last[1]).to eq('++++')
        end

        it 'sets @game_over to true' do
          subject.submit_input('4321')
          expect(subject.instance_variable_get(:@game_over)).to be(true)
        end
      end

      context 'with an arbitrary guess' do
        before(:example) do
          game = double('Game', code: '1234', submit_guess: '++--')
          subject.instance_variable_set(:@game, game)
          subject.instance_variable_set(:@guesses, [])
          subject.instance_variable_set(:@attempts, 8)
        end

        it_behaves_like '@guesses incrementer'

        it 'decrements @attempts by 1' do
          expect { subject.submit_input('4321') }
            .to change { subject.instance_variable_get(:@attempts) }.by(-1)
        end

        it 'adds a new valid entry to @guesses' do
          subject.submit_input('4231')
          expect(subject.guesses.last[1]).to eq('++--')
        end

        it 'puts feedback message' do
          expect { subject.submit_input('4231') }
            .to output(/attempts remaining/i).to_stdout
        end

        it 'sets @game_over to true when 1 attempt left' do
          subject.instance_variable_set(:@attempts, 1)
          subject.submit_input('4321')
          expect(subject.instance_variable_get(:@game_over)).to be(true)
        end
      end
    end

    context '#show_hint' do
      it 'shows game hint' do
        game = double('Game', hint: '4')
        subject.instance_variable_set(:@game, game)
        expect { subject.show_hint }
          .to output(/.+has.+4.+position/).to_stdout
      end
    end

    context '#parse_user_name' do
      it 'shows user name prompt' do
        allow(subject).to receive(:gets).and_return('mary')
        expect { subject.parse_user_name }
          .to output(/enter your name/i).to_stdout
      end

      it 'marks invalid inputs' do
        allow(subject).to receive(:gets).and_return('l#kjl', 'sd kj', 'lkjo')
        lines = capture_output { subject.parse_user_name }.split("\n")
        lines[0..1].each { |l| expect(l).to match(/invalid input/i) }
      end

      it 'returns a valid user name' do
        allow(subject).to receive(:gets).and_return('john')
        expect(subject.parse_user_name).to eq('john')
      end
    end

    context '#yes_no' do
      it 'outputs given question' do
        allow(subject).to receive(:gets).and_return('y')
        expect { subject.yes_no('Hello') }.to output(/hello/i).to_stdout
      end

      it 'marks invalid inputs' do
        allow(subject).to receive(:gets).and_return('#', 'we', '5', '2$', 'n')
        lines = capture_output { subject.yes_no('a') }.split("\n")
        lines[0..3].each { |l| expect(l).to match(/invalid/i) }
      end

      it "returns true when given 'y'" do
        allow(subject).to receive(:gets).and_return('y')
        expect(subject.yes_no('b')).to be(true)
      end

      it "returns false when given 'n'" do
        allow(subject).to receive(:gets).and_return('n')
        expect(subject.yes_no('c')).to be(false)
      end
    end
  end
end
