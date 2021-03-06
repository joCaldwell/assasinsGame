class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def clear
    reset_session
  end

  def create
    if (params[:game][:game_code] == "") or (params[:player][:name] == "") or (params[:player][:password] == "") then
      flash[:alert] = "need to fill all fields"
      redirect_back_or_to "games/new_game", allow_other_host: true
      return
    end
    @game = Game.new(game_params)
    @creator = Player.new(player_params)
    # check if the gameid is unique
    if Game.find_by game_code: @game[:game_code] then
      flash[:alert] = "Game Code Taken"
      redirect_back_or_to "games/new_game", allow_other_host: true
      return
    else
      @game.save!
      @creator.update(name: params[:player][:name], password: params[:player][:password], game_id: @game[:id])
      @game.update(game_code: params[:game][:game_code], creator_id: @creator[:id])
      @creator.save!
      session[:current_player_id] = @creator[:id]
      session[:current_game_id] = @game[:id]
      flash[:notice] = "game created"
      redirect_to games_path, allow_other_host: true
    end
  end

  def delete
    @game = Game.find_by id: session[:current_game_id]
    @players = Player.where(game: @game)
    for player in @players
      player.delete
    end
    @game.delete
    reset_session
    flash[:notice] = "game has been deleted"
    redirect_to games_path, allow_other_host: true
  end

  def die
    @player = Player.find_by id: session[:current_player_id]
    @killrequest = Killrequest.find_by victim_id: @player[:id]
    @assassin = Player.find_by id: @killrequest[:assassin_id]
    # assign next target
    @assassin.update_attribute(:target, @player[:target])
    @killrequest.delete
    @player.delete
    flash[:notice] = "You Have Been Assassinated"
    reset_session
    redirect_back_or_to games_path, allow_other_host: true
  end

  def enter
    @game = Game.find_by game_code: params[:game_code]
    if @game.present? then
      session[:current_game_id] = @game[:id]
      redirect_to "/games/#{@game[:id]}/signup", allow_other_host: true
    else
      flash[:alert] = "Game Not Found"
      redirect_back_or_to "/games/join", allow_other_host: true
    end
  end

  def index
  end

  def join
    if session[:current_game_id] && session[:current_player_id] then
      @game = Game.find_by id: session[:current_game_id]
      redirect_to "/games/#{@game[:id]}", allow_other_host: true
      return
    end
  end

  def kill
    @player = Player.find_by id: session[:current_player_id]
    @game = Game.find_by id: session[:current_game_id]
    @victim = Player.find_by id: @player[:target]
    @killrequest = Killrequest.new(game_id: @game[:id], assassin_id: @player[:id], victim_id: @victim[:id])
    if Killrequest.find_by assassin_id: @player[:id], victim_id: @victim[:id]
      flash[:alert] = "already requested ask your victim to accept"
      redirect_back_or_to "/games/#{@game[:id]}", allow_other_host: true
      return
    end
    @killrequest.save!
  end

  def new_game
    @creator = Player.new
    @game = Game.new
  end

  def show
    @game = Game.find_by id: session[:current_game_id]
    @creator = Player.find_by id: @game[:creator_id]
    @player = Player.find_by id: session[:current_player_id]
    @target = Player.find_by id: @player[:target]
    @players = Player.where(game: @game)
  end

  def signup
    @game = Game.find_by id: session[:current_game_id]
    @player = Player.new
  end

  def start
    @game = Game.find_by id: session[:current_game_id]
    @players = Player.where(game: @game)
    @shuffle = @players.shuffle()
    i = 0
    for player in @shuffle do

      if @shuffle[i + 1] then
        player.update_attribute(:target, @shuffle[i + 1][:game_id] == session[:current_game_id] ? @shuffle[i + 1][:id] : @shuffle[0][:id])
      else 
        player.update_attribute(:target, @shuffle[0][:id])
      end
      i += 1
    end
    @game.update_attribute(:is_active, true)
    flash[:notice] = "Game has started"
    redirect_back_or_to games_path, allow_other_host: true
  end
  
end
private
  def game_params
    params
      .require(:game)
      .permit(:game_code, :is_active, :creator_id)
      .with_defaults(is_active: false)
  end

  def player_params
    params
      .require(:player)
      .permit(:name, :password, :target, :dead, :game_id)
      .with_defaults(target: "none", dead: false)
  end
