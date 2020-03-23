require 'rails_helper'

describe 'Merchants API' do
  it 'sends list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)
  end

  it 'sends a merchant' do
    id = create(:merchant).id.to_s

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant[:data][:id]).to eq(id)
  end

  it 'creates a merchant' do
    merchant_params = { name: Faker::Company.name }

    post '/api/v1/merchants', params: { merchant: merchant_params }

    merchant = Merchant.last

    expect(response).to be_successful
    expect(merchant.name).to eq(merchant_params[:name])
  end

  it 'updates a merchant' do
    id = create(:merchant).id

    previous_name = Merchant.last.name
    merchant_params = { name: 'New' }

    patch "/api/v1/merchants/#{id}", params: { merchant: merchant_params }
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq('New')
  end

  it 'deletes merchant' do
    merchant = create(:merchant)

    expect(Merchant.count).to eq(1)

    delete "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect { Merchant.find(merchant.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can find a merchant based on name parameters' do
    merchant_1 = create(:merchant, name: 'Will')
    create(:merchant, name: 'other merchant')

    get '/api/v1/merchants/find?name=will'

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].count).to eq(1)
    expect(json[:data].first[:id]).to eq(merchant_1.id.to_s)
    expect(json[:data].first[:attributes][:name]).to eq(merchant_1.name)
  end

  it 'can get all merchants based on name parameters' do
    merchant_1 = create(:merchant, name: 'Will')
    merchant_2 = create(:merchant, name: 'Willy')

    get '/api/v1/merchants/find_all?name=will'

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].count).to eq(2)
    expect(json[:data].first[:id]).to eq(merchant_1.id.to_s)
    expect(json[:data].first[:attributes][:name]).to eq(merchant_1.name)

    expect(json[:data].last[:id]).to eq(merchant_2.id.to_s)
    expect(json[:data].last[:attributes][:name]).to eq(merchant_2.name)
  end

  it 'can send back a merchant for an item' do
    merchant = create(:merchant)

    5.times do
      create(:item, merchant: merchant)
    end

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful
    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].length).to eq(5)
  end
end
