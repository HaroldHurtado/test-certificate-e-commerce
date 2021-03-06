# == Schema Information
#
# Table name: orders
#
#  id          :bigint           not null, primary key
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Order < ApplicationRecord
    has_many :order_items
    validates :description, presence: true
    accepts_nested_attributes_for :order_items, :allow_destroy => true

    def preference_id
        returnValue = ""
        if Preference.where(order_id: self.id).exists?
            preference = Preference.where(order_id: self.id).first
            returnValue = preference.preference_id
        else
            returnValue = 0
        end

        returnValue
    end
end
