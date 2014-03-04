class WelcomeController < ApplicationController
  def index
    @projects = Project.where({})
  end
end
