require 'invoicexpress/models/client'

module Invoicexpress
  module Models

    class Tax < BaseModel
      include HappyMapper

      tag 'tax'
      element :id, Integer
      element :name, String
      element :value, Float
      element :region, String
      element :default_tax, Integer
    end

    class Item < BaseModel
      include HappyMapper

      tag 'item'
      element :id, Integer
      element :name, String
      element :description, String
      element :unit_price, Float
      element :quantity, Float
      element :unit, String
      has_one :tax, Tax
      element :discount, Float
    end

    class Items < BaseModel
      include HappyMapper

      tag 'items'
      attribute :type, String, :on_save => Proc.new { |value|
        "array"
      }
      has_many :items, Item
    end

    class AddressFrom < BaseModel
      include HappyMapper

      tag 'address_from'
      element :detail, String
      element :city, String
      element :postal_code, String
      element :country, String
    end

    class AddressTo < BaseModel
      include HappyMapper

      tag 'address_to'
      element :detail, String
      element :city, String
      element :postal_code, String
      element :country, String
    end

    # Fields common to all invoice models, necessary for create/update
    module BaseGuide
      def self.included(base)
        base.class_eval do
          include HappyMapper
          element :id, Integer
          element :date, Date, :on_save => DATE_FORMAT
          element :due_date, Date, :on_save => DATE_FORMAT
          element :loaded_at, Date, :on_save => DATE_TIME_FORMAT
          element :license_plate, String
          element :reference, String
          element :observations, String
          element :retention, Float
          element :tax_exemption, String
          element :sequence_id, Integer

          has_one :address_from, AddressFrom
          has_one :address_to, AddressTo
          has_one :client, Client
          has_many :items, Item, :on_save => Proc.new { |value|
            Items.new(:items => value)
          }
        end
      end
    end

    # Fields only available with GET request
    module ExtraGuide
      def self.included(base)
        base.class_eval do
          element :status, String
          element :archived, Boolean
          element :type, String
          element :sequence_number, String
          element :permalink, String
          element :currency, String
          element :sum, Float
          element :discount, Float
          element :before_taxes, Float
          element :taxes, Float
          element :total, Float
        end
      end
    end

    class TransportGuide < BaseModel
      include BaseGuide
      include ExtraGuide
      tag 'transport'
    end

    class GuideState < BaseModel
      include HappyMapper

      tag 'transport'
      element :state, String
      element :message, String
    end
  end
end
