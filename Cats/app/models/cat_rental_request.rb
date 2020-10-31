# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :bigint           not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CatRentalRequest < ApplicationRecord
    validates :cat_id, :start_date, :end_date, :status, presence: true
    validate :does_not_overlap_approved_request

    belongs_to :cat,
        foreign_key: :cat_id,
        class_name: :Cat,
        dependent: :destroy

    
    def overlapping_requests
        CatRentalRequest
            .where.not(id: id)
            .where(cat_id: cat_id)
            .where.not('start_date > :end_date OR end_date < :start_date', start_date: start_date, end_date: end_date)
    end

    def overlapping_approved_requests
        overlapping_requests.where("status = 'APPROVED'")
    end

    def overlapping_pending_requests
        overlapping_requests.where("status = 'PENDING'")
    end

    def does_not_overlap_approved_request
        return if self.denied?

        unless overlapping_approved_requests.empty?
            errors[:base] << 'Request conflicts with existing approved request'    
        end
    end
    
end
