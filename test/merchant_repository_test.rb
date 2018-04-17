# frozen_string_literal: true

require './lib/merchant'
require './test/test_helper'
require './lib/merchant_repository'
class MerchantRepositoryTest < Minitest::Test
  def setup
    @turing = [
      [:id, '1'],
      [:name, 'Turing School']
      ]
    @candisart = [
      [:id, '2'],
      [:name, 'Candisart']
      ]
    @miniaturebikez = [
      [:id, '3'],
      [:name, 'MiniatureBikez']
      ]
    @bowlsbychris = [
      [:id, '4'],
      [:name, 'bowlsbychris']
      ]
    @urcase17 = [
      [:id, '5'],
      [:name, 'urcase17']
      ]
    @merchants  = [
                  @turing,
                  @candisart,
                  @miniaturebikez,
                  @bowlsbychris,
                  @urcase17
                  ]
  end

  def test_it_exists
    mr = MerchantRepository.new(@merchants)
    assert_instance_of MerchantRepository, mr
  end

  def test_it_returns_all_merchants
    mr = MerchantRepository.new(@merchants)
    assert_instance_of Array, mr.all
    mr.all.all? do |merchant|
      assert_instance_of Merchant, merchant
    end

    expected_names = [
      'Turing School',
      'Candisart',
      'MiniatureBikez',
      'bowlsbychris',
      'urcase17'
      ]
    actual_names = mr.all.map(&:name)
    # these enums are neccesary because merchant repo creates new merchants objects from
    # passed in values. Therefore object ids cannot be checked, only values
    assert_equal expected_names, actual_names

  end

  def test_method_find_by_id
    mr = MerchantRepository.new(@merchants)
    expected = @turing.flatten.to_h
    actual = mr.find_by_id(1).attributes
    assert_equal expected, actual
    expected = @miniaturebikez.attributes
    actual = mr.find_by_id(3).attributes
    assert_equal expected, actual
    expected = @urcase17.attributes
    actual = mr.find_by_id(5).attributes
    assert_equal expected, actual
  end

  def test_method_find_by_name
    mr = MerchantRepository.new(@merchants)
    expected = 'Turing School'
    actual = mr.find_by_name(expected).name
    assert_equal expected, actual
    expected = 'MiniatureBikez'
    actual = mr.find_by_name(expected).name
    assert_equal expected, actual
    expected = 'urcase17'
    actual = mr.find_by_name(expected).name
    assert_equal expected, actual
    expected = 'Missing Merchant'
    actual = mr.find_by_name(expected)
    assert_nil actual
  end

  def test_method_find_by_name_is_case_insensitive
    mr = MerchantRepository.new(@merchants)
    assert_equal 'Turing School', mr.find_by_name('turing school').name
    assert_equal 'Turing School', mr.find_by_name('TuRinG ScHooL').name
  end

  # returns a hash of all merchants which contain a name substring
  def test_method_find_all_by_name
    mr = MerchantRepository.new(@merchants)
    actual = mr.find_all_by_name('ca')
    assert(actual.all? { |merchant| merchant.class == Merchant })
    assert_equal 'Candisart', actual[0].name
  end

  def test_helper_find_highest_id
    mr = MerchantRepository.new(@merchants)
    assert_equal 5, mr.find_highest_id
  end

  def test_method_create
    mr = MerchantRepository.new(@merchants)
    mr.create(name: 'NewMerchant')
    # tests new merchant creation and tests that new merchants have iterated id
    assert_equal 'NewMerchant', mr.find_by_name('NewMerchant').name
  end

  def test_method_create_makes_new_id_by_incrementing_highest_id
    mr = MerchantRepository.new(@merchants)
    mr.create(name: 'NewMerchant')
    assert_equal 6, mr.find_by_name('NewMerchant').id
  end

  def test_method_update
    mr = MerchantRepository.new(@merchants)
    assert_equal 'Turing School', mr.find_by_id(1).name
    mr.update(1, name: 'ZachsMerchant')
    assert_equal 'ZachsMerchant', mr.find_by_id(1).name
  end

  def test_method_delete
    mr = MerchantRepository.new(@merchants)
    assert_equal 'Turing School', mr.find_by_id(1).name
    mr.delete(1)
    assert_nil mr.find_by_id(1)
  end
end
