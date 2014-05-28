require 'spec_helper'

describe EmailValidator do
  let(:described_class) { EmailValidator }

  describe :validate_each do
    let(:validator) { described_class.new(options) }
    let(:options) { { attributes: [attribute] } }
    let(:record) { double('ActiveRecord::Base', errors: errors) }
    let(:errors) { double('ActiveModel::Errors') }
    let(:attribute) { :contact_email }

    shared_examples 'a successful validator' do
      before { expect(errors).to_not receive(:add) }
      specify { validator.validate_each(record, attribute, value) }
    end

    shared_examples 'an erroneous validator' do
      before do
        expect(errors).to receive(:add).with(attribute, :invalid_email, value: value)
      end

      specify { validator.validate_each(record, attribute, value) }
    end

    context 'with an invalid value' do
      context 'with missing @' do
        let(:value) { 'exomel.com' }
        it_behaves_like 'an erroneous validator'
      end

      context 'with missing TLD' do
        let(:value) { 'example@exomelcom' }
        it_behaves_like 'an erroneous validator'
      end
    end

    context 'with valid value' do
      let(:value) { 'example@exomel.com' }
      it_behaves_like 'a successful validator'
    end
  end
end
