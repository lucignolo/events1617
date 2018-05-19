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
		# provo ad accedere al Publisher model
		@publisherTotali = "#{Publisher.all.count}"

		@search = Search.find(params[:id])
		@ricerca = "likeat"+@search.termine

		# eseguiamo un filtraggio preliminare e calcoliamo il numero di elementi che lo soddisfano
		mioPara2 = "%"+@search.termine+"%"
		trovati = Publisher.likeat("#{mioPara2}")
		@numeroFiltrati = "#{trovati.count}"
	end	

private
  def search_params
    params.require(:search).permit(:termine, :tabella)
  end	

end
