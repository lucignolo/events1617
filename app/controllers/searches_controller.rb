class SearchesController < ApplicationController
	def index
		@searches = Search.all
	end

	def new
		@search = Search.new
	end

	def create
	   @search = Search.new(search_params)
       if @search.save
         redirect_to @search, notice: "Search successfully created!"
       else
         render :new
       end
	end

	def show
		@search = Search.find(params[:id])
		@ricerca = "likeat"+@search.termine
	end	

private
  def search_params
    params.require(:search).permit(:termine, :tabella)
  end	

end
