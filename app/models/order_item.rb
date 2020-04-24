# == Schema Information
#
# Table name: order_items
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :string
#  image_url   :string
#  quantity    :integer
#  price       :decimal(, )
#  order_id    :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class OrderItem < ApplicationRecord
  belongs_to :order

  after_save :remove_zero

  def remove_zero
      if self.price == nil or self.price <= 0
          self.destroy
      end
  end
end
