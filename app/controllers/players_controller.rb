class PlayersController < ApplicationController

  def create
    @game = Game.find_by id: session[:current_game_id]
    @player = Player.new(player_params.merge(game_id: session[:current_game_id]))
# check if the player already exists
    if Player.find_by name: @player[:name], game_id: session[:current_game_id]
# Validate Password if player exists
      @currentplayer = Player.find_by name: @player[:name], game_id: session[:current_game_id]
      if params[:player][:password] == @currentplayer[:password] then
        session[:current_player_id] = @currentplayer[:id]
        redirect_to "/games/#{@game[:id]}"
      else
        flash.now[:alert] = "Incorrect password / Name in use"
        render "games/signup"
      end
    elsif not @game[:is_active] then
#create a player if does not exist and game is inactive
      @player.save!
      session[:current_player_id] = @player[:id]
      redirect_to "/games/#{@game[:id]}"
    else
      flash.now[:alert] = "Incorrect name / can't create new player while game is active"
      render "games/signup"
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
