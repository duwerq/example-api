require 'open-uri'
require 'json'
require 'csv'

class TasksController < ApplicationController
  skip_before_filter  :verify_authenticity_token


  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all

    render json: @tasks
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])
   # render json: @task
  end


  def new
    @task = Task.new
  end


  # POST /tasks
  # POST /tasks.json
  def create

    if task_params[:website]
      self.parse_webpage(params[:task][:website])
    end
   
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      head :no_content
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy

    head :no_content
  end

  def parse_webpage(website)
 
    @website = website
    
    if @website.downcase.include? "http://"
      doc = Nokogiri::HTML(open(@website))
    else
      doc = Nokogiri::HTML(open(@website.prepend("http://")))
    end

    h1 = doc.css('h1')
    h2 = doc.css('h2')
    h3 = doc.css('h3')
    links = doc.css('a')

    h1Array = []
    h2Array = []
    h3Array = []
    linksArray = []

    h1.each do |x|
      h1Array << x.text
    end

    h2.each do |x|
      h2Array << x.text
    end

    h3.each do |x|
      h3Array << x.text
    end

    links.each do |x|
      linksArray << x['href']
    end

    @task = Task.new(h1: h1Array, h2: h2Array, h3: h3Array, links: linksArray, website: params[:task][:website])

    if @task.save
      redirect_to(@task)
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  
  end

  private

    def task_params
      params.require(:task).permit(:h1, :h2, :h3, :links, :website)
    end
end
