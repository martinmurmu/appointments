class Tag < ActiveRecord::Base

  belongs_to :manager
  belongs_to :consumer

end
