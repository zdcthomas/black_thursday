# frozen_string_literal: true

# holds, and provides methods for finding, merchants
class MerchantRepository
  def initialize(merchants)
    @merchants = {}
    input_to_hash(merchants)
  end

  # expects an array of arrays, containing strings, 1 id, 2 name
  def input_to_hash(merchants)
    merchants.each do |merchant|
      attributes = {}
      attributes[merchant[0].split(':')[0].to_sym] = merchant[0].split(':')[1].to_i
      attributes[merchant[1].split(':')[0].to_sym] = merchant[1].split(':')[1]
      @merchants[merchant[0].split(':')[1].to_i] = Merchant.new(attributes)
    end
  end

  def all
    @merchants.values
  end

  def find_by_id(id)
    @merchants[id]
  end

  def find_by_name(merchant_name)
    @merchants.values.find do |merchant|
      merchant.name.casecmp(merchant_name).zero?
    end
  end

  def find_all_by_name(name)
    @merchants.values.find_all do |merchant|
      merchant.name.downcase.include?(name.downcase)
    end
  end

  def find_highest_id
    highest_merchant = @merchants.values.max_by(&:id)
    highest_merchant.id
  end

  def create(attributes)
    attributes[:id] = (find_highest_id + 1)
    @merchants[(find_highest_id + 1)] = Merchant.new(attributes)
  end

  def update(id, attributes)
    attributes[:id] = id
    @merchants[id] = Merchant.new(attributes) 
  end

  def delete(id)
    @merchants[id] = nil
  end
end