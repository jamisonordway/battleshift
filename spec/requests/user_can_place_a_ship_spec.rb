require 'rails_helper'

describe "user can place a ship" do
  it "allows user to place a ship on their own board" do
    user1 = create(:user)
    user2 = create(:user2)
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
    game = Game.create(attributes)

    post "/api/v1/games/#{game.id}/ships?ship_size=3&start_space=A1&end_space=A3", headers: { 'X-API-Key': user1.api_key, 'CONTENT_TYPE': 'application/json'}

    data = JSON.parse(response.body)
    expect(data).to be_a(Hash)

    expect(data['message']).to eq('Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.')

    expect(Game.last.player_1_board.ships.count).to eq(1)
    expect(Game.last.player_2_board.ships.count).to eq(0)
  end

  it "will tell user when they are out of ships to place" do
    user1 = create(:user)
    user2 = create(:user2)
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
    game = Game.create(attributes)

    post "/api/v1/games/#{game.id}/ships?ship_size=3&start_space=A1&end_space=A3", headers: { 'X-API-Key': user1.api_key, 'CONTENT_TYPE': 'application/json'}

    post "/api/v1/games/#{game.id}/ships?ship_size=2&start_space=B1&end_space=C1", headers: { 'X-API-Key': user1.api_key, 'CONTENT_TYPE': 'application/json'}
    data = JSON.parse(response.body)

    expect(data).to be_a(Hash)
    expect(data['message']).to eq('Successfully placed ship with a size of 2. You have 0 ship(s) to place.')
    expect(Game.last.player_1_board.ships.count).to eq(2)
    expect(Game.last.player_2_board.ships.count).to eq(0)
  end

  it 'allows second player to place a ship' do
    user1 = create(:user)
    user2 = create(:user2)
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
    game = Game.create(attributes)

    post "/api/v1/games/#{game.id}/ships?ship_size=3&start_space=A1&end_space=A3", headers: { 'X-API-Key': user2.api_key, 'CONTENT_TYPE': 'application/json'}

    data = JSON.parse(response.body)
    expect(data).to be_a(Hash)

    expect(data['message']).to eq('Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.')
    expect(Game.last.player_1_board.ships.count).to eq(0)
    expect(Game.last.player_2_board.ships.count).to eq(1)
  end

  it "won't allow user to place too many ships" do
    user1 = create(:user)
    user2 = create(:user2)
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
    game = Game.create(attributes)

    post "/api/v1/games/#{game.id}/ships?ship_size=3&start_space=A1&end_space=A3", headers: { 'X-API-Key': user1.api_key, 'CONTENT_TYPE': 'application/json'}

    post "/api/v1/games/#{game.id}/ships?ship_size=2&start_space=B1&end_space=C1", headers: { 'X-API-Key': user1.api_key, 'CONTENT_TYPE': 'application/json'}

    post "/api/v1/games/#{game.id}/ships?ship_size=2&start_space=C2&end_space=C3", headers: { 'X-API-Key': user1.api_key, 'CONTENT_TYPE': 'application/json'}

    expect(response).to_not be_success
    data = JSON.parse(response.body)

    expect(data).to be_a(Hash)
    expect(data['message']).to eq('You have already placed all your ships.')
    expect(Game.last.player_1_board.ships.count).to eq(2)
    expect(Game.last.player_2_board.ships.count).to eq(0)
  end
end
