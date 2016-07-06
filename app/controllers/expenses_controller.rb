# app/controllers/expenses_controller.rb

class ExpensesController < ApplicationController
  def index
  end
  
  def show
    @expense = Expense.find_by_id(params[:id])
  end
  
  def new
  end
  
  def create
    expense = Expense.new(expense_params)
    expense.paid_by = current_user
    
    charge_to = params[:charges][:users]
    amount = expense.amount/charge_to.length
    charge_to.each do |user_id, amnt|
      charge = Charge.new(:completed => false, :amount => amount)
      expense.charges << charge
      charge.charged_to = User.find_by_id(user_id)
      charge.save
    end
    
    if expense.save
      redirect_to expenses_path
    else
      redirect_to new_expense_path
    end
  end
  
  def edit
    @expense = Expense.find_by_id(params[:id])
  end
  
  def update
    @expense = Expense.find_by_id(params[:id])
    @expense.update_attributes!(expense_params)
    flash[:success] = "The expense has been updated"
    redirect_to expenses_path
  end
  
  def destroy
    @expense = Expense.find_by_id(params[:id])
    @expense.destroy!
    redirect_to expenses_path
  end
  
  private
  
  def expense_params
    params.require(:expense).permit(:name, :amount, :date, :category, :details, :deadline)
  end
  
  
end