# app/controllers/expenses_controller.rb

class ExpensesController < ApplicationController
  def index
  end

  def show
    @show = true
    @expense = Expense.find_by_id(params[:id])
  end

  def new
  end

  def create
    expense = Expense.new(expense_params)
    expense.paid_by = current_user

    charge_to = params[:charges][:users]
    charge_to.each do |user_id, amnt|
      if amnt.to_i > 0
        charge = Charge.new(:completed => false, :amount => amnt)
        expense.charges << charge
        charge.charged_to = User.find_by_id(user_id)
        charge.save
      end
    end

    if expense.save
      redirect_to expenses_path
    else
      redirect_to new_expense_path
    end
  end

  def edit
    @expense = Expense.find_by_id(params[:id])
    if current_user != @expense.paid_by
      redirect_to expenses_path
      flash[:warning] = "You can not edit this expense."
    else 
      @charges = {}
      @expense.charges.each do |charge|
        @charges[charge.charged_to] = charge
      end
    end
  end

  def update
    @expense = Expense.find_by_id(params[:id])
    @expense.update_attributes!(expense_params)
    flash[:success] = "The expense has been updated"
    redirect_to expenses_path
  end

  def destroy
    @expense = Expense.find_by_id(params[:id])
    if current_user != @expense.paid_by
      redirect_to expenses_path
      flash[:warning] = "You can not delete this expense."
    else 
      @expense.destroy!
      redirect_to expenses_path
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount, :date, :category, :details, :deadline)
  end


end
