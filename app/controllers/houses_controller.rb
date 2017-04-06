class HousesController < ApplicationController
  before_action :set_house, only: [:show, :edit, :update, :destroy, :invite_user]

  # GET /houses
  # GET /houses.json
  def index
    @houses = House.all
  end

  # GET /houses/1
  # GET /houses/1.json
  def show
  end

  # GET /houses/new
  def new
    @house = House.new
    render :layout => "empty"
  end

  def add_landlord
    @house = House.find_by_id(params[:id])
    @landlords = []
    @house.landlords.each do |landlord|
      @landlords << landlord
    end
    @landlords << Landlord.new
    render 'edit'
  end

  # GET /houses/1/edit
  def edit
    @users = @house.users
    @landlords = @house.landlords
    if !@landlords.any?
      @landlords = []
      @landlords << Landlord.new
    end
  end

  # POST /houses
  # POST /houses.json
  def create
    house = House.new(house_params)
    current_user.house = house
    current_user.save
    redirect_to root_path
  end

  # PATCH/PUT /houses/1
  # PATCH/PUT /houses/1.json
  def update
    if House.find_by_id(params[:id]) != current_house
      flash[:warning] = "You cannot edit settings for this house, edit settings for your own house here."
      redirect_to edit_house_path(current_house)
    else
      current_house.update_attributes!(house_params)

      # TODO: what is this?
      fine_params = params[:fine_rule]
      puts :fine_params
      puts fine_params
      puts :fine_rule
      puts current_house.fine_rule
      if not current_house.fine_rule
        current_house.fine_rule = FineRule.new(fine_params)
      else
        current_house.fine_rule.update_attributes!(fine_params)
      end

      flash[:success] = "House settings updated."
      redirect_to root_path
    end
  end

  # DELETE /houses/1
  # DELETE /houses/1.json
  def destroy
    @house.destroy
    respond_to do |format|
      format.html { redirect_to houses_url, notice: 'House was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def invite_user
    render :json => @house.id
  end

  def join
    house = House.find_by_id(params[:house][:invite_code])
    current_user.update_attributes!(:house => house)
    redirect_to '/'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_house
      @house = House.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def house_params
      params.require(:house).permit(:name)
    end
end
