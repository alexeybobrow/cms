module EmployeesHelper
  def switch_employed_link
    if params[:show] == 'all'
      link_to t('admin.employees.hide_retired'), show: nil
    else
      link_to t('admin.employees.show_retired'), show: 'all'
    end
  end
end

