class Account::ItemsController < Account::ApplicationController
  account_load_and_authorize_resource :item, through: :team, through_association: :items

  # GET /account/teams/:team_id/items
  # GET /account/teams/:team_id/items.json
  def index
    delegate_json_to_api
  end

  # GET /account/items/:id
  # GET /account/items/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/items/new
  def new
  end

  # GET /account/items/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/items
  # POST /account/teams/:team_id/items.json
  def create
    respond_to do |format|
      if @item.save
        format.html { redirect_to [:account, @team, :items], notice: I18n.t("items.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @item] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/items/:id
  # PATCH/PUT /account/items/:id.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to [:account, @item], notice: I18n.t("items.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @item] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/items/:id
  # DELETE /account/items/:id.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :items], notice: I18n.t("items.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  include strong_parameters_from_api

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
