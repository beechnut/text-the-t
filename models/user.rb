class User < ActiveRecord::Base

  validates :phone_number, presence: true
  validates :language, inclusion: { in: %w( English Spanish Portuguese ) }
  validates :total_sent, presence:       true,
                         numericality: { only_integer: true,
                                        greater_than:  1     }

end