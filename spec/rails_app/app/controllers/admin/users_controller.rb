module Admin
  class UsersController < BaseController
    before_filter :require_admin!
    before_filter :new_user, only: [:new, :create]
    before_filter :find_user, only: [:show, :edit, :update, :delete, :destroy]

    def index
      @users = User.for_admin(params[:show])
    end

    def show
    end

    def new
    end

    def create
      if @user.update_attributes(user_params)
        redirect_to [:admin, @user]
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @user.update_attributes(user_params)
        redirect_to [:admin, @user]
      else
        render :edit
      end
    end

    def delete
    end

    def destroy
      @user.safe_delete
      redirect_to [:admin, :users]
    end

    private

    def new_user
      @user = User.new
    end

    def find_user
      @user = User.find params[:id]
    end

    def user_params
      params.require(:user).permit(:username, :is_admin, :is_locked)
    end
  end
end
