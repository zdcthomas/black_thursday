# frozen_string_literal: true
require 'pry'

require_relative './analyst_helper/helper'
# analyses various aspects of sales engine
# allows for analysis of different sales engine respoitories
class SalesAnalyst
  include AnalystHelper

  attr_reader :all_items_per_merchant,
              :all_invoices_per_merchant

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @all_items_per_merchant = @sales_engine.all_items_per_merchant
    @all_invoices_per_merchant = @sales_engine.all_invoices_per_merchant
    @all_invoices_per_day = @sales_engine.all_invoices_per_day
  end

  def find_sum(numbers)
    numbers.inject(0) { |sum, number| sum + number }
  end

  def find_mean(numbers)
    sum = find_sum(numbers)
    sum / numbers.count.to_f
  end

  def standard_deviation(numbers)
    mean = find_mean(numbers)
    diff_from_mean = numbers.map do |number|
      mean - number
    end
    squared = diff_from_mean.map do |number|
      number**2
    end
    sum = find_sum(squared)
    sum_over_count = (sum / (numbers.count - 1))
    Math.sqrt(sum_over_count)
  end

  def std_dev_above_mean(data_point, mean, standard_deviation)
    std_dev = standard_deviation
    diff_from_mean = data_point - mean
    (diff_from_mean / std_dev).round(2)
  end

  def merchant_price_averages
    merchant_price_averages = []
    @all_items_per_merchant.each_key do |merchant_id|
      merchant_price_averages << average_item_price_for_merchant(merchant_id)
    end
    merchant_price_averages
  end

  def average_average_price_per_merchant
    merchant_price_averages
    find_mean(merchant_price_averages).round(2)
  end

  def invoice_paid_in_full?(id)
    transactions_per_inv = @sales_engine.all_transactions_per_invoice
    if transactions = transactions_per_inv[id]
      transactions.any? do |transaction|
        transaction.result == :success
      end
    else
      return false
    end
  end

  def fake_total(invoice_id)
    prices = @sales_engine.all_invoice_items_by_invoice[invoice_id].map do |invoice_item|
      invoice_item.unit_price * invoice_item.quantity
    end
    return prices.inject(0){|sum, number| sum+number}
  end

  def invoice_total(invoice_id)
    prices = @sales_engine.all_invoice_items_by_invoice[invoice_id].map do |invoice_item|
      invoice_item.unit_price * invoice_item.quantity
    end
    if invoice_paid_in_full?(invoice_id)
      return prices.inject(0){|sum, number| sum+number}
    else
      return 0
    end
  end


  def top_buyers(n = 20)
    @sales_engine.customers_by_invoice_total[0...n]
  end

  def top_merchant_for_customer(customer_id)
    merchants = @sales_engine.merchants_per_customer_id[customer_id]
    # binding.pry
    sorted = merchants.max_by do |merchant|
      merchant[1].length
    end
    binding.pry
    sorted[0]
  end
end
