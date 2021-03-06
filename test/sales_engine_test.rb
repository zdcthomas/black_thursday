# frozen_string_literal: true
require_relative '../lib/item_repository'
require_relative '../lib/merchant_repository'
require './test/test_helper'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test
  def setup
    @se = SalesEngine.from_csv(
      items: './data/items.csv',
      merchants: './data/merchants.csv',
      invoices: './data/invoices.csv',
      invoice_items: './data/invoice_items.csv',
      transactions: './data/transactions.csv',
      customers: './data/customers.csv'
      )
  end

  def test_it_exists
    assert_instance_of SalesEngine, @se
  end

  def test_all_items_per_by_merchant
    assert_equal 475, @se.all_items_per_merchant.keys.count
    assert_equal 1367, @se.all_items_per_merchant.values.flatten.count
  end

  def test_all_items_prices_per_item
    assert_equal 1367, @se.all_item_prices_per_item.keys.count
    assert_equal 1367,  @se.all_item_prices_per_item.values.flatten.count
  end

  def test_it_contains_repositories
    assert_instance_of ItemRepository, @se.items
    assert_instance_of MerchantRepository, @se.merchants
    assert_instance_of SalesAnalyst, @se.analyst
    assert_instance_of InvoiceRepository, @se.invoices
  end

  def test_all_invoices_per_merchant
    assert_equal 475, @se.all_invoices_per_merchant.keys.count
    assert_equal 4985, @se.all_invoices_per_merchant.values.flatten.count
  end

  def test_from_csv
    actual = SalesEngine.from_csv(
      items: './data/items.csv',
      merchants: './data/merchants.csv',
      invoices: './data/invoices.csv',
      invoice_items: './data/invoice_items.csv',
      transactions: './data/transactions.csv',
      customers: './data/customers.csv')
    assert_instance_of SalesEngine, actual
  end

  def test_all_invoices_per_day
    assert_equal 7, @se.all_invoices_per_day.keys.count
    assert_equal 4985, @se.all_invoices_per_day.values.flatten.count
    assert_equal 701, @se.all_invoices_per_day.values[1].count
    assert_equal 741, @se.all_invoices_per_day.values[2].count
  end

  def test_transactions_per_invoice
    assert_instance_of Hash, @se.all_transactions_per_invoice
    assert_equal 4985, @se.all_transactions_per_invoice.values.flatten.count
  end

  def test_find_all_invoice_items_by_invoice_id
    actual = @se.all_invoice_items_by_invoice
    assert_instance_of Hash, actual
  end

  def test_all_invoice_items_by_customer
    actual = @se.all_invoice_items_by_customer
    assert_equal 901, actual.keys.length
    assert_instance_of Customer, actual.keys[0]
    assert_equal 21830, actual.values.flatten.length
    assert_instance_of Array, actual.values[0]
    assert_instance_of InvoiceItem, actual.values[0][0]
  end

end
