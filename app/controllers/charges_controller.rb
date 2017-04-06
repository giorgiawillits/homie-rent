class ChargesController < ApplicationController
  before_action :set_charge, only: [:show, :edit, :update, :destroy]

  # GET /charges
  # GET /charges.json
  def index
    @charges = Charge.all
  end

  # GET /charges/1
  # GET /charges/1.json
  def show
  end

  # GET /charges/new
  def new
    @charge = Charge.new
  end

  # GET /charges/1/edit
  def edit
  end

  # POST /charges
  # POST /charges.json
  def create
    @charge = Charge.new(charge_params)
  end

  # PATCH/PUT /charges/1
  # PATCH/PUT /charges/1.json
  def update
  end

  def update_status
    charge = Charge.find_by_id(params[:id])
    if current_user != charge.paid_by
      redirect_to expense_path(charge.expense)
      flash[:warning] = "You cannot update the status of this charge."
    else
      charge.update_attributes(:completed => params[:completed])
      render json: {}
    end
  end

  # DELETE /charges/1
  # DELETE /charges/1.json
  def destroy
    @charge.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_charge
      @charge = Charge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def charge_params
      params.require(:charge).permit(:completed, :amount)
    end
end
