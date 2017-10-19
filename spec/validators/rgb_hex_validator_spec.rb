require 'spec_helper'

describe RgbHexValidator do
  let(:described_class) { RgbHexValidator }

  describe :validate_each do
    let(:validator) { described_class.new(options) }
    let(:options) { { attributes: [attribute] } }
    let(:record) { double('ActiveRecord::Base', errors: errors) }
    let(:errors) { double('ActiveModel::Errors') }
    let(:attribute) { :color }

    before { allow(record).to receive(:color=).with(expected_stored_value) }

    shared_examples 'a successful validator' do
      before { expect(errors).to_not receive(:add) }
      specify { validator.validate_each(record, attribute, value) }
    end

    shared_examples 'an erroneous validator' do
      before do
        expect(errors).to receive(:add).with(attribute, :invalid_rgb_hex, value: expected_stored_value)
      end

      specify { validator.validate_each(record, attribute, value) }
    end

    context 'with an invalid value' do
      context 'with missing characters' do
        let(:value) { '#bb' }
        let(:expected_stored_value) { '#bb' }
        it_behaves_like 'an erroneous validator'
      end

      context 'containing invalid characters' do
        let(:value) { '#bababz' }
        let(:expected_stored_value) { '#babab' }
        it_behaves_like 'an erroneous validator'
      end

      context 'not starting with #' do
        let(:value) { 'bababa' }
        let(:expected_stored_value) { 'bababa' }
        it_behaves_like 'an erroneous validator'
      end
    end

    context 'with valid value' do
      context 'with six characters' do
        let(:value) { '#ffffff' }
        let(:expected_stored_value) { '#ffffff' }

        it_behaves_like 'a successful validator'
      end

      context 'with three characters' do
        let(:value) { '#fff' }
        let(:expected_stored_value) { '#fff' }

        it_behaves_like 'a successful validator'
      end
    end
  end
end
