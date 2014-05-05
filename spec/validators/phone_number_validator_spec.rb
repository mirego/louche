require 'spec_helper'

describe PhoneNumberValidator do
  describe :validate_each do
    let(:validator) { described_class.new(options) }
    let(:options) { { attributes: [attribute] } }
    let(:record) { double('ActiveRecord::Base', errors: errors) }
    let(:errors) { double('ActiveModel::Errors') }
    let(:attribute) { :phone }

    before { allow(record).to receive(:phone=).with(expected_stored_value) }

    shared_examples 'a successful validator' do
      before { expect(errors).to_not receive(:add) }
      specify { validator.validate_each(record, attribute, value) }
    end

    shared_examples 'an erroneous validator' do
      before do
        expect(errors).to receive(:add).with(attribute, :invalid_phone_number, value: expected_stored_value)
      end

      specify { validator.validate_each(record, attribute, value) }
    end

    context 'with an invalid value' do
      context 'with missing digits' do
        let(:value) { '555-2525' }
        let(:expected_stored_value) { '5552525' }
        it_behaves_like 'an erroneous validator'
      end

      context 'containing invalid characters' do
        let(:value) { '514 555-252A' }
        let(:expected_stored_value) { '514555252' }
        it_behaves_like 'an erroneous validator'
      end
    end

    context 'with valid value' do
      context 'with spaces and dashes' do
        let(:value) { '514 555-2525' }
        let(:expected_stored_value) { '5145552525' }

        it_behaves_like 'a successful validator'
      end

      context 'without spaces' do
        let(:value) { '5145552525' }
        let(:expected_stored_value) { '5145552525' }

        it_behaves_like 'a successful validator'
      end

      context 'containing trailing characters' do
        let(:value) { '  514 555-2525  ' }
        let(:expected_stored_value) { '5145552525' }
        it_behaves_like 'a successful validator'
      end
    end
  end
end
