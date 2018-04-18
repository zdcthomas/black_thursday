# provides repo methods for Transaction repo
module TransactionHelper
  def find_all_by_invoice_id(tr)
    @repository.values.find_all do |transaction|
      transaction.invoice_id == tr
    end
  end

  def find_all_by_credit_card_number(tr)
    @repository.values.find_all do |transaction|
      transaction.credit_card_number == tr
    end
  end

  def find_all_by_result(tr)
    @repository.values.find_all do |transaction|
      transaction.result == tr
    end
  end
end
