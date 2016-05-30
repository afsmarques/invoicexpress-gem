require 'invoicexpress/models'

module Invoicexpress
  class Client
    module TransportGuides
      # Returns all the information about a transport guide:
      # - Basic information (date, status, sequence number)
      # - Client
      # - Document items
      # - Document timeline
      # Document timeline is composed by:
      # - Date, time and the user who created it
      # - Type of the event
      # The complete list of timeline events is:
      # - create
      # - edited
      # - send_email
      # - canceled
      # - deleted
      # - settled
      # - second_copy
      # - archived
      # - unarchived
      # - comment
      #
      # @param guide_id [String] Requested transport guide id
      # @return [Invoicexpress::Models::TransportGuide] The requested transported_guide
      # @raise Invoicexpress::Unauthorized When the client is unauthorized
      # @raise Invoicexpress::NotFound When the transport guide doesn't exist
      def transport_guide(transport_guide_id, options={})
        params = { :klass => Invoicexpress::Models::TransportGuide }

        get("transports/#{transport_guide_id}.xml", params.merge(options))
      end

      # Creates a new simplified invoice. Also allows to create a new client and/or new items in the same request.
      # If the client name does not exist a new one is created.
      # If items do not exist with the given names, new ones will be created.
      # If item name  already exists, the item is updated with the new values.
      # Regarding item taxes, if the tax name is not found, no tax is applyed to that item.
      # Portuguese accounts should also send the IVA exemption reason if the invoice contains exempt items(IVA 0%)
      #
      # @param transport_guide [Invoicexpress::Models::TransportGuide] The transport guide to create
      # @return [Invoicexpress::Models::SimplifiedInvoice] The created transport guide
      # @raise Invoicexpress::Unauthorized When the client is unauthorized
      # @raise Invoicexpress::UnprocessableEntity When there are errors on the submission
      def create_transport_guide(transport_guide, options={})
        raise(ArgumentError, "transport guide has the wrong type") unless transport_guide.is_a?(Invoicexpress::Models::TransportGuide)

        params = { :klass => Invoicexpress::Models::TransportGuide, :body  => transport_guide }

        post("transports.xml", params.merge(options))
      end

      # Changes the state of a transport guide.
      # Possible state transitions:
      # - draft to final – finalized
      # - draft to deleted – deleted
      # - settled to final – unsettled
      # - final to second copy – second_copy
      # - final or second copy to canceled – canceled
      # - final or second copy to settled – settled
      # Any other transitions will fail.
      # When canceling a simplified invoice you must specify a reason.
      #
      # @param transport_guide_id [String] The transport guide id to change
      # @param transport_guide_state [Invoicexpress::Models::GuideState] The new state
      # @return [Invoicexpress::Models::TransportGuide] The updated transport guide
      # @raise Invoicexpress::Unauthorized When the client is unauthorized
      # @raise Invoicexpress::UnprocessableEntity When there are errors on the submission
      # @raise Invoicexpress::NotFound When the transport guide doesn't exist
      def update_transport_guide_state(transport_guide_id, transport_guide_state, options={})
        raise(ArgumentError, "transport guide state has the wrong type") unless transport_guide_state.is_a?(Invoicexpress::Models::GuideState)

        params = { :klass => Invoicexpress::Models::TransportGuide, :body => transport_guide_state }
        put("transports/#{transport_guide_id}/change-state.xml", params.merge(options))
      end

      # Sends the transport guide through email
      #
      # @param transport_guide_id [String] The transport guide id to send
      # @param message [Invoicexpress::Models::Message] The message to send
      # @raise Invoicexpress::Unauthorized When the client is unauthorized
      # @raise Invoicexpress::UnprocessableEntity When there are errors on the submission
      # @raise Invoicexpress::NotFound When the transport guide doesn't exist
      def transport_guide_mail(transport_guide_id, message, options={})
        raise(ArgumentError, "message has the wrong type") unless message.is_a?(Invoicexpress::Models::Message)

        params = { :body => message, :klass => Invoicexpress::Models::TransportGuide }
        put("transports/#{transport_guide_id}/email-document.xml", params.merge(options))
      end

      # Generates the transport guide pdf url
      #
      # @param transport_guide_id [String] The transport guide id to get pdf url
      # @raise Invoicexpress::Unauthorized When the client is unauthorized
      # @raise Invoicexpress::UnprocessableEntity When there are errors on the submission
      # @raise Invoicexpress::NotFound When the transport guide doesn't exist
      def transport_guide_pdf_url(transport_guide_id, options={})
        params = { :klass => Invoicexpress::Models::Output }

        get("api/pdf/#{transport_guide_id}.xml", params.merge(options))
      end
    end
  end
end
