# == Schema Information
#
# Table name: preferences
#
#  id            :integer          not null, primary key
#  preference_id :string
#  order_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Preference < ApplicationRecord
end
