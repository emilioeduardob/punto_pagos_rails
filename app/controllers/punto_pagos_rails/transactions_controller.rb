module PuntoPagosRails
  class TransactionsController < ApplicationController
    def create
      srv = TransactionService.new(resource_id)

      if srv.create
        redirect_to srv.process_url
      else
        render_payment_error_view srv.error
      end
    end

    def notification
      response = TransactionService.notificate(params, request.headers)
      render json: response
    end

    def success
      @resource = Transaction.find_by(token: params[:token]).resource
    end

    def error
      @resource = Transaction.find_by(token: params[:token]).resource
      translated_error = I18n.t("punto_pagos_rails.errors.invalid_puntopagos_payment")
      render_payment_error_view translated_error
    end

    private

    def render_payment_error_view
      render error_template, locals: { error_key: error_key }
    end

    def error_template
      'error'
    end

    def resource_id
      @resource_id ||= begin
        params.require(:resource_id)
        params[:resource_id]
      end
    end
  end
end
