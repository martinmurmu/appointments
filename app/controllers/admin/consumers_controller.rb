class Admin::ConsumersController < AdminController

  # GET /admin/consumers
  # GET /admin/consumers.json
  def index
    @consumers = Consumer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @consumers }
    end
  end

  # GET /admin/consumers/1
  # GET /admin/consumers/1.json
  def show
    @consumer = Consumer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @consumer }
    end
  end

  # GET /admin/ppointments/new
  # GET /admin/consumers/new.json
  def new
    @consumer = Consumer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @consumer }
    end
  end

  # GET /admin/consumers/1/edit
  def edit
    @consumer = Consumer.find(params[:id])
  end

  # POST /admin/consumers
  # POST /admin/consumers.json
  def create
    @consumer = Consumer.new(params[:consumer])

    respond_to do |format|
      if @consumer.save
        format.html { redirect_to admin_consumer_path(@consumer), notice: 'Consumer was successfully created.' }
        format.json { render json: admin_consumer_path(@consumer), status: :created, location: @consumer }
      else
        format.html { render action: "new" }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/consumers/1
  # PUT /admin/consumers/1.json
  def update
    @consumer = Consumer.find(params[:id])

    respond_to do |format|
      if @consumer.update_attributes(params[:consumer])
        format.html { redirect_to admin_consumer_path(@consumer), notice: 'Consumer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/consumers/1
  # DELETE /admin/consumers/1.json
  def destroy
    @consumer = Consumer.find(params[:id])
    @consumer.destroy

    respond_to do |format|
      format.html { redirect_to admin_consumers_path }
      format.json { head :no_content }
    end
  end
end
