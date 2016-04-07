module Admin
  class OccupationsController < BaseController
    before_filter :new_occupation, only: [:new, :create]
    before_action :find_occupation, only: [:edit, :show, :update, :position, :destroy, :restore]

    def index
      @occupations = Occupation.actual(params[:show])
    end

    def position
      @occupation.insert_at(params[:position].to_i)
      render nothing: true, status: :ok
    end

    def new; end
    def show; end
    def edit; end

    def create
      if @occupation.update_attributes(occupation_params)
        redirect_to [:admin, @occupation]
      else
        render :new
      end
    end

    def update
      if @occupation.update_attributes(occupation_params)
        redirect_to [:admin, @occupation]
      else
        render :edit
      end
    end

    def destroy
      @occupation.safe_delete
      redirect_to [:admin, :occupations]
    end

    def restore
      @occupation.restore
      redirect_to [:admin, :occupations]
    end

    private

    def new_occupation
      @occupation = Occupation.new
    end

    def find_occupation
      @occupation = Occupation.find params[:id]
    end

    def occupation_params
      params.require(:occupation).permit(:name, :name_ru)
    end
  end
end
