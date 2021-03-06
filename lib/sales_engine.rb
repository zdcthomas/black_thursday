# frozen_string_literal: true
require_relative './item_repository'
require_relative './merchant_repository'
require_relative './sales_analyst'
require_relative './invoice_repository'
require_relative './invoice_item_repository'
require_relative './transaction_repository'
require_relative './customer_repository'
require_relative './fileio'

# allows creation and access to items and merchants
class SalesEngine
  attr_reader :items,
              :merchants,
              :analyst,
              :invoices,
              :invoice_items,
              :transactions,
              :customers
  def initialize(paths)
    @items = ItemRepository.new(FileIo.load(paths[:items]))
    @merchants = MerchantRepository.new(FileIo.load(paths[:merchants]))
    @invoices = InvoiceRepository.new(FileIo.load(paths[:invoices]))
    @invoice_items = InvoiceItemRepository.new(FileIo.load(paths[:invoice_items]))
    @transactions = TransactionRepository.new(FileIo.load(paths[:transactions]))
    @customers = CustomerRepository.new(FileIo.load(paths[:customers]))
    @analyst = SalesAnalyst.new(self)
  end

  def all_items_per_merchant
    @items.all.group_by(&:merchant_id)
  end

  def all_item_prices_per_item
    item_price_per_item = {}
    @items.all.each do |item|
      item_price_per_item[item] = item.unit_price
    end
    item_price_per_item
  end

  def all_invoices_per_merchant
    @invoices.all.group_by(&:merchant_id)
  end

  def self.from_csv(path)
    SalesEngine.new(path)
  end

  def all_invoices_per_day
    @invoices.all.group_by { |invoice| invoice.created_at.strftime('%A') }
  end

  def all_transactions_per_invoice
    @transactions.all.group_by(&:invoice_id)
  end

  def all_invoice_items_by_invoice
    @invoice_items.all.group_by(&:invoice_id)
  end

  def all_invoice_items_by_customer
    @invoice_items.all.group_by do |invoice_item|
      invoice = @invoices.find_by_id(invoice_item.invoice_id)
      @customers.find_by_id(invoice.customer_id)
    end
  end

  def customers_by_total_invoice_totals
    customer_by_total_invoice_totals = {}
    customers_by_invoice = @invoices.all.group_by(&:customer_id)
    customers_by_invoice.each do |customer, invoices|
      total = invoices.reduce(0) do |sum, invoice|
        sum + @analyst.invoice_total(invoice.id)
      end
      customer_by_total_invoice_totals[customer] = total
    end
    customer_by_total_invoice_totals
  end
  def customers_by_invoice_total
    customer_by_total_invoice_totals = customers_by_total_invoice_totals
    top_customers = customer_by_total_invoice_totals.sort_by{|key,value|value}
    top_customers.reverse.map do |customer_pair|
      customer_id = customer_pair[0]
      @customers.find_by_id(customer_id)
    end
  end

  def invoice_items_per_customer_id
    @invoice_items.all.group_by do |invoice_item|
      @invoices.find_by_id(invoice_item.invoice_id).customer_id
    end
  end

end
