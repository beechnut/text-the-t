class User < ActiveRecord::Base

  self.primary_key = :phone_number

  validates :phone_number, presence: true, uniqueness: true
  validates :language, inclusion: { in: %w( English Spanish Portuguese ) }
  validates :total_sent, presence:       true,
                         numericality: { only_integer: true,
                                         greater_than_or_equal:  1     }

  def stops
    saved_stops
  end

  def should_receive_help?
    total_sent == 1 || total_sent % 3 == 0
  end

  def should_receive_tip?
    total_sent == 1 || total_sent % 5 == 0
  end

end