class LbooksController < ApplicationController
  before_action :set_lbook, only: [:show, :edit, :update, :destroy]

  # GET /lbooks
  # GET /lbooks.json
  def index
    #@lbooks = Lbook.where('id > 10').limit(20).order('id asc').paginate(page: params[:page], per_page: 10)
    @lbooks = Lbook.limit(50).offset(10)
    #.paginate(page: params[:page], per_page: 10)
    #@lbooks = Lbook.find_by_sql("select id, c01_vecchioid, c02_titolo FROM lbooks WHERE id < '200' ").order(:id).paginate(page: params[:page], per_page: 10)
  end

  # GET /lbooks/1
  # GET /lbooks/1.json
  def show
  end

  # GET /lbooks/new
  def new
    @lbook = Lbook.new
  end

  # GET /lbooks/1/edit
  def edit
  end

  # POST /lbooks
  # POST /lbooks.json
  def create
    @lbook = Lbook.new(lbook_params)

    respond_to do |format|
      if @lbook.save
        format.html { redirect_to @lbook, notice: 'Lbook was successfully created.' }
        format.json { render :show, status: :created, location: @lbook }
      else
        format.html { render :new }
        format.json { render json: @lbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lbooks/1
  # PATCH/PUT /lbooks/1.json
  def update
    respond_to do |format|
      if @lbook.update(lbook_params)
        format.html { redirect_to @lbook, notice: 'Lbook was successfully updated.' }
        format.json { render :show, status: :ok, location: @lbook }
      else
        format.html { render :edit }
        format.json { render json: @lbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lbooks/1
  # DELETE /lbooks/1.json
  def destroy
    @lbook.destroy
    respond_to do |format|
      format.html { redirect_to lbooks_url, notice: 'Lbook was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lbook
      @lbook = Lbook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lbook_params
      params.require(:lbook).permit(:c01_vecchioid, :c02_titolo, :c03_prezzoeurodec, :c04_EDIZIONE, :c05_IDDISTRIBUTORE, :c06_IDSERIE, :c07_ISBN, :c08_copie, :c09_deposito, :c10_publisher_id, :c11_IDTIPOOPERA, :c12_ANNOEDIZIONE, :c13_note, :c14_idaliquotaiva, :c15_url2)
    end
end
