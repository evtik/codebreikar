require 'spec_helper'

module Codebreaker
  describe Game do
    context '#initialize' do
      it 'generates a secret code' do
        expect(subject.code).not_to be_empty
      end

      it 'saves a 4-number secret code' do
        expect(subject.code.length).to eq(4)
      end

      it 'saves a secret code consisted of numbers from 1 to 6' do
        expect(subject.code).to match(/[1-6]{4}/)
      end
    end

    context '#submit_guess' do
      data = [
        ['1111', '2222', ''],
        ['1211', '3333', ''],
        ['1121', '3333', ''],
        ['1112', '3333', ''],
        ['1112', '4444', ''],
        ['1212', '3456', ''],
        ['3334', '3331', '+++'],
        ['3433', '3133', '+++'],
        ['3343', '3313', '+++'],
        ['4333', '1333', '+++'],
        ['4332', '1332', '+++'],
        ['4323', '1323', '+++'],
        ['4233', '1233', '+++'],
        ['2345', '2346', '+++'],
        ['2534', '2634', '+++'],
        ['2354', '2364', '+++'],
        ['1234', '5123', '---'],
        ['3612', '1523', '---'],
        ['3612', '2531', '---'],
        ['1234', '5612', '--'],
        ['1234', '5621', '--'],
        ['4321', '1234', '----'],
        ['3421', '1234', '----'],
        ['3412', '1234', '----'],
        ['4312', '1234', '----'],
        ['1423', '1234', '+---'],
        ['1342', '1234', '+---'],
        ['5255', '2555', '++--'],
        ['5525', '2555', '++--'],
        ['5552', '2555', '++--'],
        ['6262', '2626', '----'],
        ['6622', '2626', '++--'],
        ['2266', '2626', '++--'],
        ['2662', '2626', '++--'],
        ['6226', '2626', '++--'],
        ['3135', '3315', '++--'],
        ['3513', '3315', '++--'],
        ['3351', '3315', '++--'],
        ['1353', '3315', '+---'],
        ['5313', '3315', '++--'],
        ['1533', '3315', '----'],
        ['5331', '3315', '+---'],
        ['5133', '3315', '----'],
        ['3361', '3315', '++-'],
        ['3136', '3635', '++-'],
        ['1336', '6334', '++-'],
        ['1363', '6323', '++-'],
        ['1633', '6233', '++-'],
        ['1234', '4343', '--']
      ]

      data.each do |d|
        it "code '#{d[1]}' with guess '#{d[0]}' gives '#{d[2]}'" do
          subject.instance_variable_set(:@code, d[1])
          expect(subject.submit_guess(d[0])).to eq(d[2])
        end
      end
    end

    context '#hint' do
      it 'returns the code\'s arbitrary digit' do
        expect(subject.code).to include(subject.hint)
      end

      it 'returns the same digit all the time' do
        expect(subject.hint).to eq(subject.hint)
      end
    end
  end
end
