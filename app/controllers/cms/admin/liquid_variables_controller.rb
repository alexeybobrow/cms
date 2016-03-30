module Cms
  module Admin
    class LiquidVariablesController < ::Cms::Admin::BaseController
      before_filter :find_variable, only: [:edit, :update, :destroy]

      def index
        @variables = LiquidVariable.all
      end

      def new
        @variable = LiquidVariable.new
      end

      def create
        @variable = LiquidVariable.new(variable_params)

        if @variable.save
          redirect_to [:admin, :liquid_variables]
        else
          render :new
        end
      end

      def edit; end

      def update
        if @variable.update_attributes(variable_params)
          redirect_to [:admin, :liquid_variables]
        else
          render :edit
        end
      end

      def destroy
        @variable.destroy
        redirect_to [:admin, :liquid_variables]
      end

      private

      def find_variable
        @variable ||= LiquidVariable.find(params[:id])
      end

      def variable_params
        params.require(:liquid_variable).permit(:name, :value)
      end
    end
  end
end
