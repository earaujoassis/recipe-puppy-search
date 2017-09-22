class RecipesController < ApplicationController
  def index
    if params[:q].present?
      @query = params[:q]
      finder_service = ::RecipePuppyService.new
      query_result = finder_service.search_for(@query, 20).deep_symbolize_keys!
      @entries = query_result[:results]
    end
  end
end
