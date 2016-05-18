module Invoicexpress
  module Models

    class Output < BaseModel
      include HappyMapper

      element :pdfUrl, String
    end

  end
end
