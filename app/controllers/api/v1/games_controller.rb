module Api
  module V1
    class GamesController < ActionController::API
      def create
        key = request.env["HTTP_X_API_KEY"]
        user1 = User.find_by(api_key: key)
        user2 = User.find_by(email: params[:opponent_email])
        b1 = Board.new(4)
        b2 = Board.new(4)
        attributes = {
          player_1: user1,
          player_2: user2,
          player_1_board: b1,
          player_2_board: b2,
          player_1_turns: 0,
          player_2_turns: 0,
          current_turn: "player 1"
        }
        game = Game.create!(attributes)
 
        render json: game
      end

      def show
        if Game.exists?(params[:id])
          binding.pry
          game = Game.find(params[:id])
          render json: game
        else
          render json: {"message" => "Bad request"}, status: 400
        end
      end
    end
  end
end
