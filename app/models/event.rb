# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  periodicity :string
#  start_date  :date
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_events_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Event < ApplicationRecord
  extend Enumerize

  belongs_to :user

  validates :title, presence: true
  validates :start_date, presence: true
  validates :periodicity, presence: true

  enumerize :periodicity, in: [:once, :daily, :weekly, :monthly, :yearly], default: :once

end
