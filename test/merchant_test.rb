# frozen_string_literal: true

require './test/test_helper'
require './lib/merchant'

class MerchantTest < Minitest::Test
  def test_it_exists
    merchant = Merchant.new(id: 5, name: 'Turing School', created_at: '2010-12-10', updated_at: '2011-12-04')
    assert_equal 5, merchant.id
    assert_equal 'Turing School', merchant.name
  end

  def test_it_has_id
    merchant = Merchant.new(id: 5, name: 'Turing School', created_at: '2010-12-10', updated_at: '2011-12-04')
    assert_equal 5, merchant.id
  end
end
