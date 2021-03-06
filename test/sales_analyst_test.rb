# frozen_string_literal: true

require './lib/merchant_repository'
require './lib/sales_engine'
require './test/test_helper'
require './lib/sales_analyst'

class SalesAnalystTest < Minitest::Test
  def setup
    @sales_engine_full = SalesEngine.new(
      items: './data/items.csv',
      merchants: './data/merchants.csv',
      invoices: './data/invoices.csv',
      invoice_items: './data/invoice_items.csv',
      transactions: './data/transactions.csv',
      customers: './data/customers.csv'
      )
    @sa = SalesAnalyst.new(@sales_engine_full)
  end

  def test_it_exists
    assert_instance_of SalesAnalyst, @sa
  end

  def test_all_items_per_by_merchant
    assert_equal 475, @sa.all_items_per_merchant.keys.count
    assert_equal 1367, @sa.all_items_per_merchant.values.flatten.count
  end

  def test_average_items_per_merchant
    assert_equal 2.88, @sa.average_items_per_merchant
  end

  def test_can_find_sum
    @sa.find_sum([3, 4])
    assert_equal 7, @sa.find_sum([3, 4])
  end

  def test_can_find_mean
    @sa.find_mean([4, 4])
    assert_equal 4, @sa.find_mean([4, 4])
  end

  def test_it_can_find_standard_deviation
    @sa.standard_deviation([10, 15, 20])
    assert_equal 5, @sa.standard_deviation([10, 15, 20])
  end

  def test_it_can_return_standard_deviation_of_average_items_per_merchant
    expected = @sa.average_items_per_merchant_standard_deviation
    assert_equal 3.26, expected
    assert_equal Float, expected.class
  end

  def test_find_std_dev_above_mean
    standard_deviation = 3.26
    mean = 2.88
    data_point = 20
    expected = @sa.std_dev_above_mean(data_point, mean, standard_deviation)
    assert_equal 5.25, expected
  end

  def test_high_merchant_item_count
    expected = @sa.merchants_with_high_item_count
    assert_equal 52, expected.count
    assert_instance_of Merchant, expected[0]
  end

  def test_can_call_item_price_by_merchant
    @sa.merchants_with_high_item_count
    merchant_id = 12334105
    expected = @sa.average_item_price_for_merchant(merchant_id)

    assert_equal 16.66, expected
    assert_equal BigDecimal, expected.class
  end

  def test_can_find_average_price_of_all_merchant_items
    expected = @sa.average_average_price_per_merchant

    assert_equal 350.29, expected
    assert_equal BigDecimal, expected.class
  end

  def test_can_find_average_invoices_per_merchant
    expected = @sa.average_invoices_per_merchant
    assert_equal 10.49, expected
    assert_instance_of Float, expected
  end

  def test_average_invoices_per_merchant_standard_deviation
    expected = @sa.average_invoices_per_merchant_standard_deviation
    assert_equal 3.29, expected
    assert_instance_of Float, expected
  end

  def test_top_merchants_by_invoice_count
    expected = @sa.top_merchants_by_invoice_count

    assert_equal 12, expected.count
    assert_instance_of Merchant, expected.first
  end

  def test_bottom_merchants_by_invoice_count
    expected = @sa.bottom_merchants_by_invoice_count

    assert_equal 4, expected.count
    assert_instance_of Merchant, expected.first
  end

  def test_top_days_by_invoice_count
    expected = @sa.top_days_by_invoice_count

    assert_equal "Wednesday", expected.first
    assert_instance_of String, expected.first
  end

  def test_invoice_paid_in_full
    actual = @sa.invoice_paid_in_full?(1)
    assert actual
  end

  def test_it_returns_total_amount_of_invoice_by_invoice_id
    expected = @sa.invoice_total(7)
    assert_instance_of BigDecimal, expected
    assert_equal 0.1702232e5, expected
  end

  def test_top_buyers
    actual = @sa.top_buyers(2)
    assert_equal 2, actual.length
    assert_instance_of Customer, actual[0]
    actual = @sa.top_buyers(6)
    assert_equal 6, actual.length
    assert_instance_of Customer, actual[5]
  end

  def test_top_merchant_for_customer
    id = 100
    actual = @sa.top_merchant_for_customer(id)
    assert_instance_of Merchant, actual
    assert_equal 12336753, actual.id
  end
end
