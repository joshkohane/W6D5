require 'action_view'

# == Schema Information
#
# Table name: cats
#
#  id          :bigint           not null, primary key
#  birth_date  :date             not null
#  color       :string
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Cat < ApplicationRecord
    include ActionView::Helpers::DateHelper
    validates :name, :birth_date, :color, :sex, :description, presence: true

    COLORS = ['Orange', 'White', 'Black', 'Calico', 'Tabby', 'Brown']

    has_many :rental_requests,
        foreign_key: :cat_id,
        class_name: :CatRentalRequests

    def age
        time_ago_in_words(birth_date)
    end
end
