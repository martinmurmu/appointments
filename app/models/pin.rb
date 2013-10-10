class Pin < ActiveRecord::Base

  belongs_to :appointment
  belongs_to :consumer

  attr_accessible :pin

  before_create :generate_pin

  protected

  def generate_pin
    self.pin = loop do
      random_pin = SecureRandom.random_number(9999)
      break random_pin unless Pin.exists?(pin: random_pin)
    end
  end
end
