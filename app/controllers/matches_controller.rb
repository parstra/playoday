class MatchesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource_and_authorize_resource

  def edit
  end

  def update
  end

  def show
  end

end
