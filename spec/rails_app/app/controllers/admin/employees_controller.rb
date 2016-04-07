module Admin
  class EmployeesController < BaseController
    before_filter :new_employee, only: [:new, :create]
    before_filter :find_employee, only: [:edit, :update, :show, :hire, :retire]

    def index
      @employees = Employee.for_admin(params[:show])
    end

    def create
      if @employee.update_attributes(employee_params)
        redirect_to [:admin, @employee]
      else
        render :new
      end
    end

    def show; end
    def new; end
    def edit; end

    def hire
      @employee.hire!
      render :show
    end

    def retire
      @employee.retire!
      render :show
    end

    def update
      if @employee.update_attributes(employee_params)
        redirect_to admin_employee_path(@employee)
      else
        render :edit
      end
    end

    private

    def new_employee
      @employee = Employee.new
    end

    def find_employee
      @employee = Employee.find params[:id]
    end

    def employee_params
      params.require(:employee).permit(:name, :occupation_id, :name_ru, :position, :position_ru, :avatar, :remove_avatar)
    end
  end
end
