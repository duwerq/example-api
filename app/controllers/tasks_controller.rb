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
    render json: @task
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
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

  def scrape_webpage
    require 'open-uri'
    require 'json'

    

    doc = Nokogiri::HTML(open("http://theonlyobstacle.com"))
    h1 = doc.css('h1').text
    h2 = doc.css('h2').text
    h3 = doc.css('h3').text
    links = doc.css('a')

    linksArray = []

    links.each do |x|

      linksArray << x['href']
    end
 
    @task = Task.new(h1: h1, h2: h2, h3: h3, links: linksArray, website: params[:task][:website])

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end

    

  
  end

  private

    def task_params
      params.require(:task).permit(:h1, :h2, :h3, :links, :website)
    end
end
