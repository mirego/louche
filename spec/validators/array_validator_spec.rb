require 'spec_helper'

describe ArrayValidator do
  describe :validate_each do
    let(:validator) { described_class.new(options) }
    let(:options) { { attributes: [attribute], validity_method: validity_method } }
    let(:record) { double('ActiveRecord::Base', errors: errors) }
    let(:errors) { double('ActiveModel::Errors') }
    let(:attribute) { :items }

    shared_examples 'a successful validator' do
      before { expect(errors).to_not receive(:add) }
      specify { validator.validate_each(record, attribute, value) }
    end

    shared_examples 'an erroneous validator' do
      before do
        expect(errors).to receive(:add).with(attribute, :invalid_array, value: value)
      end

      specify { validator.validate_each(record, attribute, value) }
    end

    context 'with default validity method' do
      let(:validity_method) { :valid? }
      let(:valid_item) { double('ArrayItem', valid?: true) }
      let(:invalid_item) { double('ArrayItem', valid?: false) }

      context 'with an invalid value' do
        context 'with non-Array value' do
          let(:value) { valid_item }
          it_behaves_like 'an erroneous validator'
        end

        context 'with value containing invalid item' do
          let(:value) { [valid_item, invalid_item] }
          it_behaves_like 'an erroneous validator'
        end

        context 'with empty value' do
          let(:value) { [] }
          it_behaves_like 'an erroneous validator'
        end
      end

      context 'with valid value' do
        let(:value) { [valid_item, valid_item, valid_item] }
        it_behaves_like 'a successful validator'
      end
    end

    context 'with custom validity method' do
      let(:validity_method) { :really_valid? }
      let(:valid_item) { double('ArrayItem', really_valid?: true) }
      let(:invalid_item) { double('ArrayItem', really_valid?: false) }

      context 'with an invalid value' do
        context 'with non-Array value' do
          let(:value) { valid_item }
          it_behaves_like 'an erroneous validator'
        end

        context 'with value containing invalid item' do
          let(:value) { [valid_item, invalid_item] }
          it_behaves_like 'an erroneous validator'
        end

        context 'with empty value' do
          let(:value) { [] }
          it_behaves_like 'an erroneous validator'
        end
      end

      context 'with valid value' do
        let(:value) { [valid_item, valid_item, valid_item] }
        it_behaves_like 'a successful validator'
      end
    end
  end
end
