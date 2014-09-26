class Manager < ActiveRecord::Base

  has_one :user, :as => :rolable

  has_many :appointments
  has_many :tags
  has_many :pins, :through => :appointments
  has_many :consumers, :through => :tags

  attr_accessible :name, :phone, :token

  validates :name, :phone, :presence => true

  # before_create :generate_token_seo
  before_save :generate_token_seo

  def to_s
    name
  end
  
  def user
    User.where(:rolable_type=>'manager', :rolable_id=>self.id).first    
  end
  
  def manager_name
    name
  end
  
  def creation_date
    created_at
  end
  
  def last_login_date
    if user.nil? 
      "No assigned User Account."
    else
      user.last_sign_in_at
    end
  end

  def self.notify_waitlists
    managers = self.all

    client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])

    managers.each do |manager|
      manager.consumers.each do |consumer|
        message = "You are still on the #{manager.practice_name} waitlist."
        message += " If you'd like to be removed please reply 'X #{manager.id}' to this message"
        message += " and we remove you from the waitlist."

        # Create and send an SMS message. Message must be editable?
        logger.debug "Remainder message..."
        logger.debug "From: #{manager.phone}"
        logger.debug "To: #{consumer.phone_number}"
        logger.debug "Message: #{message}"

        client.account.sms.messages.create(
          from: TWILIO_CONFIG['from'],
          to: consumer.phone_number,
          body: message
        )
      end
    end

  end

  private
  
  def generate_token_hash
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: self.token)
  end

  def generate_token_seo
    self.token = self.name + "-" + self.phone
    self.token = self.token.delete(",.").gsub(/ /, "-")
  end

end
