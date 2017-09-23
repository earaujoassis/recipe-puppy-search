require 'test_helper'

class RecipesFeatureTest < ActionDispatch::IntegrationTest
  test 'Recipes search interface' do
    page.visit '/'
    assert page.has_content? 'Please provide a recipe to search :)'
  end

  test 'Recipes search interface with non-blank query' do
    page.visit '/?q=omelet'
    assert page.has_content? 'Baked Omelet With Broccoli & Tomato'
  end

  test 'Perfom complete search' do
    page.visit '/'
    page.within("#search-form") do
      fill_in 'q', with: 'omelet'
    end
    page.click_button 'Search'
    assert page.has_content? 'Baked Omelet With Broccoli & Tomato'
  end
end
