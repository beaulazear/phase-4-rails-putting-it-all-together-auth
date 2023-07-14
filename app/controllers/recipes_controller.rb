class RecipesController < ApplicationController

    before_action :authorize
    # skip_before_action :authorize, only: [:index]

    def index
        recipes = Recipe.all
        render json: recipes, status: :created
        
        # if session.include? :user_id
        # else
        #     render json: { error: recipes.errors.full_messages }, status: :unauthorized
        # end
    end

    def create
        recipe = Recipe.create(recipe_params) do |f|
            f.user_id = session[:user_id]
        end
        if recipe.valid?
            render json: recipe, status: :created
        else
            render json: { errors: ["Invalid recipe information"] }, status: :unprocessable_entity
        end
    end

    private

    def authorize
        return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id 
    end

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end
end
