class PublishersController < ApplicationController

  # layout 'nuovoindice0'   serviva per provare animazioni esterne in jquery

  before_action :set_publisher, only: [:show, :edit, :update, :destroy]

  # GET /publishers
  # GET /publishers.json
  def index


    if @tipo == "nonbidoni"
      @publishers = Publisher.nonbidoni
    else
      @publishers = Publisher.bidoni
    end  

    mioHash = analizzaScope(params[:scope], /^(likeat)(.+)$/)
    mioNome = mioHash[:nome]
    mioPara = mioHash[:para] 
    #
    case mioNome
     when "nonbidoni"
       @publishers = Publisher.nonbidoni
     when "bidoni"
       @publishers = Publisher.bidoni

     when "likeat"
       mioPara2 = "%"+mioPara+"%"
       @publishers = Publisher.likeat("#{mioPara2}").order(:nome).paginate(page: params[:page], per_page: 5)
           #@products = Product.all.paginate(page: params[:page], per_page: 5)
       # prova 02/07 da StackOverfkow
       #@total_items = [@publishers].compact.flatten
       #Kaminari.paginate_array(@total_items).page(params[:page]).per(10)

       #@events = Event.likeat(mioPara'%kata%')   
    else
       @publishers = Publisher.all.order(:nome).page params[:page]
       #@events = Event.upcoming.page(params[:page]) 
    end     

    
  end

  # GET /publishers/1
  # GET /publishers/1.json
  def show
  end

  # GET /publishers/new
  def new
    @publisher = Publisher.new
  end

  # GET /publishers/1/edit
  def edit
  end

  # POST /publishers
  # POST /publishers.json
  def create
    @publisher = Publisher.new(publisher_params)

    respond_to do |format|
      if @publisher.save
        format.html { redirect_to @publisher, notice: 'Publisher was successfully created.' }
        format.json { render :show, status: :created, location: @publisher }
      else
        format.html { render :new }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publishers/1
  # PATCH/PUT /publishers/1.json
  def update
    respond_to do |format|
      if @publisher.update(publisher_params)
        format.html { redirect_to @publisher, notice: 'Publisher was successfully updated.' }
        format.json { render :show, status: :ok, location: @publisher }
      else
        format.html { render :edit }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publishers/1
  # DELETE /publishers/1.json
  def destroy
    @publisher.destroy
    respond_to do |format|
      format.html { redirect_to publishers_url, notice: 'Publisher was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publisher
      @publisher = Publisher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def publisher_params
      params.require(:publisher).permit(:nome, :vecchioid)
    end

    def analizzaScope(stringa, pattern)
     match = pattern.match(stringa)
     if match
       mioh = { nome: match[1], para: match[2] }
     else
       mioh = { nome: stringa, para: nil }
     end
  end
end
