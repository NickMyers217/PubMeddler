require 'open-uri'

class QueriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_query, only: [:show, :edit, :update, :destroy, :run]
  before_filter :user_is_current_user, only: [:show, :edit, :update, :destroy, :run]

  # GET /queries/1/run
  def run
    urlString = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=#{@query.journal}[journal]"
    urlString += " AND #{@query.term}" if @query.term.length > 0
    urlString += "&retmax=#{@query.retmax}" if @query.retmax > 0
    urlString += "&datetype=pdat&mindate=#{@query.mindate}"
    urlString += "&maxdate=#{@query.maxdate}"

    url = URI.escape(urlString)
    @ids = Nokogiri::HTML(open(url)).xpath("//id")

    urlString = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&retmode=xml&id="
    @ids.each { |id| urlString += "#{id.inner_html}," }
    url = URI.escape(urlString)
    #puts url

    @summaries = Hash.from_xml(Nokogiri::HTML(open(url)).to_xml)['html']['body']['pubmedarticleset']
  end

  # GET /queries
  # GET /queries.json
  def index
    @queries = current_user.queries
  end

  # GET /queries/1
  # GET /queries/1.json
  def show
  end

  # GET /queries/new
  def new
    @query = Query.new
  end

  # GET /queries/1/edit
  def edit
  end

  # POST /queries
  # POST /queries.json
  def create
    @query = Query.new(query_params)
    @query.user_id = current_user.id

    respond_to do |format|
      if @query.save
        format.html { redirect_to @query, notice: 'Query was successfully created.' }
        format.json { render :show, status: :created, location: @query }
      else
        format.html { render :new }
        format.json { render json: @query.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /queries/1
  # PATCH/PUT /queries/1.json
  def update
    respond_to do |format|
      if @query.update(query_params)
        format.html { redirect_to @query, notice: 'Query was successfully updated.' }
        format.json { render :show, status: :ok, location: @query }
      else
        format.html { render :edit }
        format.json { render json: @query.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /queries/1
  # DELETE /queries/1.json
  def destroy
    @query.destroy
    respond_to do |format|
      format.html { redirect_to queries_url, notice: 'Query was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def user_is_current_user
      unless current_user.id == @query.user_id
        flash[:notice] = "You may only interact with your own queries."
        redirect_to queries_path
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_query
      @query = Query.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def query_params
      params.require(:query).permit(:title, :journal, :term, :retmax, :mindate, :maxdate)
    end
end
