class PlayersController < ApplicationController

  def create
    if (params[:player][:name] == "") or (params[:player][:password] == "") then
      flash[:alert] = "fill all fields"
      redirect_to "games/signup", allow_ther_host: true
    end
    @game = Game.find_by id: session[:current_game_id]
    @player = Player.new(player_params.merge(game_id: session[:current_game_id]))
# check if the player already exists
    if Player.find_by name: @player[:name], game_id: session[:current_game_id]
# Validate Password if player exists
      @currentplayer = Player.find_by name: @player[:name], game_id: session[:current_game_id]
      if params[:player][:password] == @currentplayer[:password] then
        session[:current_player_id] = @currentplayer[:id]
        redirect_to "/games/#{@game[:id]}", allow_other_host: true
      else
        flash[:alert] = "Incorrect password / Name in use"
        redirect_to "games/signup", allow_other_host: true
      end
    elsif not @game[:is_active] then
#create a player if does not exist and game is inactive
      @player.save!
      session[:current_player_id] = @player[:id]
      redirect_to "/games/#{@game[:id]}", allow_other_host: true
    else
      flash[:alert] = "Incorrect name / can't create new player while game is active"
      redirect_to "games/signup", allow_other_host: true
    end
  end
end

private
  def player_params
    params
      .require(:player)
      .permit(:name, :password, :target, :dead, :game_id)
      .with_defaults(target: "none", dead: false)
  end
