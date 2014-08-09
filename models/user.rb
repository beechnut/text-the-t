class User < ActiveRecord::Base

  self.primary_key = :phone_number

  validates :phone_number, presence: true, uniqueness: true
  validates :language, inclusion: { in: %w( English Spanish Portuguese ) }
  validates :total_sent, presence:       true,
                         numericality: { only_integer: true,
                                         greater_than_or_equal:  1     }

end