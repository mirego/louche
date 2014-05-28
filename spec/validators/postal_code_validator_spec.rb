require 'spec_helper'

describe PostalCodeValidator do
  let(:described_class) { PostalCodeValidator }

  describe :validate_each do
    let(:validator) { described_class.new(options) }
    let(:options) { { attributes: [attribute] } }
    let(:record) { double('ActiveRecord::Base', errors: errors) }
    let(:errors) { double('ActiveModel::Errors') }
    let(:attribute) { :postal_code }

    before { allow(record).to receive(:postal_code=).with(expected_stored_value) }

    shared_examples 'a successful validator' do
      before { expect(errors).to_not receive(:add) }
      specify { validator.validate_each(record, attribute, value) }
    end

    shared_examples 'an erroneous validator' do
      before do
        expect(errors).to receive(:add).with(attribute, :invalid_postal_code, value: expected_stored_value)
      end

      specify { validator.validate_each(record, attribute, value) }
    end

    context 'with an invalid value' do
      context 'with missing characters' do
        let(:value) { 'G0R 2T' }
        let(:expected_stored_value) { 'G0R2T' }

        it_behaves_like 'an erroneous validator'
      end

      context 'with invalid characters' do
        let(:value) { 'GOR2T$' }
        let(:expected_stored_value) { 'GOR2T' }

        it_behaves_like 'an erroneous validator'
      end
    end

    context 'with valid value' do
      context 'with spaces' do
        let(:value) { ' G 0R 2T 0 ' }
        let(:expected_stored_value) { 'G0R2T0' }

        it_behaves_like 'a successful validator'
      end

      context 'without spaces' do
        let(:value) { 'G0R2T0' }
        let(:expected_stored_value) { 'G0R2T0' }

        it_behaves_like 'a successful validator'
      end

      context 'with trailing characters' do
        let(:value) { '  G0R2T0  ' }
        let(:expected_stored_value) { 'G0R2T0' }

        it_behaves_like 'a successful validator'
      end
    end
  end
end
