require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    merchant = create(:merchant)
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item[:type]).to eq('item')
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)
    end
  end

  it "can send a specific item" do
    merchant = create(:merchant)
    new_item = create(:item, merchant: merchant)
    get "/api/v1/items/#{new_item.id}"
    expect(response).to be_successful
    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(new_item.id.to_s)
  end

  it 'can create new item' do
    merchant = create(:merchant)
    item_params = {
      name: 'New Item',
      description: 'good',
      unit_price: 1.00,
      merchant_id: merchant.id
    }

    post '/api/v1/items', params: item_params

    item = Item.last

    expect(response).to be_successful
    expect(item.name).to eq(item_params[:name])
    expect(item.description).to eq(item_params[:description])
  end

  it 'can update an item' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    id = item.id

    put "/api/v1/items/#{id}", params: { name: 'New name' }

    last_item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(last_item.name).to_not eq(item.name)
    expect(last_item.name).to eq('New name')
  end

  it 'can delete an item' do
    merchant = create(:merchant)

    new_item = create(:item, merchant: merchant)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{new_item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(new_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can send back a merchant for a specific item' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful
    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data][:attributes][:name]).to eq(merchant.name)
  end

  it "sends all items matching a query" do
    merchant = Merchant.create(name: "MonsterShop")
    item_1 = create(:item, name: 'water bottle', description: 'Item used to store liquid', merchant: merchant)
    item_2 = create(:item, name: 'bottled water', description: 'cold', merchant: merchant)
    get "/api/v1/items/find_all?description=liquid"
    expect(response).to be_successful
    json = JSON.parse(response.body)["data"]
    expect(json.count).to eq(1)
    expect(json[0]["id"]).to eq(item_1.id.to_s)
  end

  it 'can find an item using name parameters' do
    merchant = create(:merchant)
    item_1 = create(:item, name: 'water bottle', description: 'Item used to store liquid', merchant: merchant)
    item_2 = create(:item, name: 'bottled water', description: 'cold', merchant: merchant)

    get '/api/v1/items/find?name=bottle'

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].count).to eq(1)
    expect(json[:data].first[:id]).to eq(item_1.id.to_s)
    expect(json[:data].first[:attributes]).to have_key(:name)
    expect(json[:data].first[:attributes][:name]).to eq(item_1.name)
  end
end
