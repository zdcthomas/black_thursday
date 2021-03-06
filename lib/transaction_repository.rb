# frozen_string_literal: true

require_relative './repository'
require_relative './transaction'
require 'time'
# holds transactions
class TransactionRepository
  include Repository

  attr_reader :repository

  def initialize(transactions)
    create_repository(transactions, Transaction)
  end

  def create(attributes)
    general_create(attributes, Transaction)
  end
end
