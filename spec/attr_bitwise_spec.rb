require_relative '../lib/attr_bitwise.rb'

describe AttrBitwise do

  # test class in order to test concern
  class TestClass

    include AttrBitwise

    attr_accessor :fruits_value
    attr_accessor :vegetables_value

    attr_bitwise :fruits, mapping: [:banana, :apple]
    attr_bitwise :vegetables, mapping: [:carrot, :pepper]

    def initialize
      @fruits_value = 0
      @vegetables_value = 0
    end

  end

  subject { TestClass.new }

  context '.to_bitwise_values' do

    context 'with Hash argument' do
      it do
        expect(
          TestClass.to_bitwise_values(
            {
              a: :apple,
              b: :banana
            },
            'fruits'
          )
        ).to eq [2, 1]
      end
    end

    context 'with Array argument' do
      it do
        expect(TestClass.to_bitwise_values(
          [:apple, :banana],
          'fruits'
        )).to eq [2, 1]
      end
    end

    context 'with Fixnum argument' do
      it do
        expect(TestClass.to_bitwise_values(1, 'fruits')).to eq 1
      end
    end

  end

  context 'with `fruits` attribute_name' do

    context '#fruits=' do

      before { subject.fruits = [:banana, :apple] }

      it 'should set proper value' do
        expect(subject.fruits_value).to eq 3
        expect(subject.fruits).to eq [:banana, :apple]
      end

      it 'shouldn\'t set values in other field' do
        expect(subject.vegetables_value).to eq 0
        expect(subject.vegetables).to eq []
      end

    end

    context '#fruits==' do

      context 'when value is incorrect' do
        before { subject.fruits = [:banana, :apple] }

        it do
          expect(subject.fruits == :banana).to eq false
        end
      end

      context 'when value is correct' do
        before { subject.fruits = [:banana] }

        it do
          expect(subject.fruits == :banana).to eq true
        end
      end

    end

    context 'with `fruits_value` = 0' do
      context '#fruits' do

        it do
          expect(subject.fruits).to eq []
        end

      end

      context '#add_fruit' do

        it do
          subject.add_fruit(:banana)
          expect(subject.fruits).to eq [:banana]
        end

        context 'when called twice, each type remains unique' do
          it do
            subject.add_fruit(:banana)
            subject.add_fruit(:banana)
            expect(subject.fruits).to eq [:banana]
          end
        end

      end

      context '#fruit?(:banana)' do

        it do
          expect(subject.fruit?(:banana)).to eq false
        end

      end
    end

    context 'with `fruits_value` = 3' do

      before { subject.fruits_value = 3 }

      context '#fruits' do

        it do
          expect(subject.fruits).to eq [:banana, :apple]
        end

      end

      context '#fruit?(:banana)' do

        it do
          expect(subject.fruit?(:banana)).to eq true
        end

      end

      context '#remove_fruit' do

        it do
          subject.remove_fruit(:banana)
          expect(subject.fruits).to eq [:apple]
        end

      end

      context '#fruits_union' do

        it do
          expect(subject.fruits_union(1, 2)).to eq [1, 3, 2]
        end

      end

      context '.bitwise_union' do

        it do
          expect(
            TestClass.bitwise_union(1, 2, 'fruits')
          ).to eq [1, 3, 2]
        end

      end

      context '#bitwise_intersection' do

        it do
          expect(
            TestClass.bitwise_intersection(1, 2, 'fruits')
          ).to eq [3]
        end

      end

    end

  end
end
