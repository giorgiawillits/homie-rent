# app/controllers/expenses_controller.rb
require 'koala'
require 'pp'

class ExpensesController < ApplicationController
  def index
    @expenses = current_house.expenses

    # @graph = Koala::Facebook::API.new(current_user.oauth_token)
    #
    # profile = @graph.get_object("me")
    # print "*" * 100
    # pp profile
    # pp current_user.uid
    # print "*" * 100
    # Bot.deliver({
    #   recipient: {
    #     id: "1438986869505849"
    #   },
    #   message: {
    #     text: 'Hey #{current_user.full_name}'
    #   }
    # }, access_token: ENV['ACCESS_TOKEN'])
  end

  def show
    @show = true
    @expense = Expense.find_by_id(params[:id])
    puts @expense.paid_by
    puts current_user
    puts @expense.paid_by == current_user
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
      flash[:success] = "Successfully saved expense."
      redirect_to expenses_path
    else
      flash[:danger] = "Could not save expense."
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
    expense = Expense.find_by_id(params[:id])
    expense.update_attributes!(expense_params)

    charge_to = params[:charges][:users]
    charge_to.each do |user_id, amnt|
      charge = expense.charges.find_by_user_id(user_id)

      if charge == nil and amnt.to_i > 0
        charge = Charge.new(:completed => false, :amount => amnt)
        expense.charges << charge
        charge.charged_to = User.find_by_id(user_id)
        charge.save
      elsif charge != nil
        if amnt == 0
          charge.destroy!
        else
          charge.update_attributes(:amount => amnt)
        end
      end
    end

    flash[:success] = "The expense has been updated."
    redirect_to expense_path(expense)
  end

  def destroy
    @expense = Expense.find_by_id(params[:id])
    if current_user != @expense.paid_by
      redirect_to expenses_path
      flash[:warning] = "You can not delete this expense."
    else
      @expense.destroy!
      flash[:success] = "The expense was deleted."
      redirect_to expenses_path
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount, :date, :category, :details, :deadline)
  end

end
