module Invoicexpress
  module Models

    class Pdf < BaseModel
      include HappyMapper

      element :pdfUrl, String
    end

  end
end
