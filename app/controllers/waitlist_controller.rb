class WaitlistController < ApplicationController
  def index
    @consumer = Consumer.new
    @username = params[:token]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @consumer }
    end
  end
  
  def show
    @manager = Manager.where(:token => params[:token]).first
    @consumer = Consumer.new

    respond_to do |format|
      if @manager
        format.html
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    end
  end

  def new_consumer
    url = root_path + '/waitlist/' + params[:token]

    @manager = Manager.where(:token => params[:token]).first

    @consumer = Consumer.where(params[:consumer]).create
    @consumer.phone_number = params[:consumer][:phone_number].delete(" ")

    respond_to do |format|
      if @consumer.save
        @consumer.tags.create(
          :manager_id => @manager.id,
          :tags => "external"
        )
        logger.debug @consumer
        format.html { redirect_to url, notice: 'Well done! You had been waitlisted and will receive our broadcasts.' }
      else
        format.html { redirect_to url, alert: 'Something goes wrong! Please try again.' }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end
end
