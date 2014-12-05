require 'aasm'

module PuntoPagosRails
  class Transaction < ActiveRecord::Base
    include AASM

    belongs_to :resource, class_name: PuntoPagosRails.resource_class_name

    delegate :amount, :to => :resource

    aasm :column => :state do
      state :pending, :initial => true
      state :completed
      state :rejected

      event :complete do
        transitions :from => :pending, :to => :completed
      end

      event :reject do
        transitions :from => :pending, :to => :rejected
      end
    end

    def reject_with(error)
      self.error = error
      self.reject
    end

    def amount_to_s
      "%0.2f" % amount.to_i
    end

  end
end
