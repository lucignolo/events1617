class LpublishersController < ApplicationController
  before_action :set_lpublisher, only: [:show, :edit, :update, :destroy]

  # GET /lpublishers
  # GET /lpublishers.json
  def index
    @lpublishers = Lpublisher.all
  end

  # GET /lpublishers/1
  # GET /lpublishers/1.json
  def show
  end

  # GET /lpublishers/new
  def new
    @lpublisher = Lpublisher.new
  end

  # GET /lpublishers/1/edit
  def edit
  end

  # POST /lpublishers
  # POST /lpublishers.json
  def create
    @lpublisher = Lpublisher.new(lpublisher_params)

    respond_to do |format|
      if @lpublisher.save
        format.html { redirect_to @lpublisher, notice: 'Lpublisher was successfully created.' }
        format.json { render :show, status: :created, location: @lpublisher }
      else
        format.html { render :new }
        format.json { render json: @lpublisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lpublishers/1
  # PATCH/PUT /lpublishers/1.json
  def update
    respond_to do |format|
      if @lpublisher.update(lpublisher_params)
        format.html { redirect_to @lpublisher, notice: 'Lpublisher was successfully updated.' }
        format.json { render :show, status: :ok, location: @lpublisher }
      else
        format.html { render :edit }
        format.json { render json: @lpublisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lpublishers/1
  # DELETE /lpublishers/1.json
  def destroy
    @lpublisher.destroy
    respond_to do |format|
      format.html { redirect_to lpublishers_url, notice: 'Lpublisher was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lpublisher
      @lpublisher = Lpublisher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lpublisher_params
      params.require(:lpublisher).permit(:ID_EDITORE, :Nome)
    end
end
