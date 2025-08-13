require 'rails_helper'

RSpec.describe "Frames", type: :request do
  describe 'POST /frames' do
    it 'cria um quadro com círculos válidos' do
      params = {
        frame: {
          center_x: 50,
          center_y: 50,
          width: 100,
          height: 100,
          circles_attributes: [
            { center_x: 60, center_y: 60, diameter: 20 },
            { center_x: 80, center_y: 80, diameter: 10 }
          ]
        }
      }
      post '/frames', params: params, as: :json
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['circles'].size).to eq(2)
    end

    it 'retorna erro se círculos se sobrepõem' do
      params = {
        frame: {
          center_x: 50,
          center_y: 50,
          width: 100,
          height: 100,
          circles_attributes: [
            { center_x: 60, center_y: 60, diameter: 30 },
            { center_x: 70, center_y: 60, diameter: 30 }
          ]
        }
      }
      post '/frames', params: params, as: :json
      expect(response).to have_http_status(:unprocessable_content)
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end

  describe 'GET /frames/:id' do
    let!(:frame) do
      Frame.create!(
        center_x: 50,
        center_y: 50,
        width: 100,
        height: 100,
        circles_attributes: [
          { center_x: 60, center_y: 80, diameter: 20 }, 
          { center_x: 80, center_y: 20, diameter: 10 }, 
          { center_x: 40, center_y: 50, diameter: 15 },
          { center_x: 90, center_y: 50, diameter: 15 }  
        ]
      )
    end

    it 'retorna detalhes do quadro e métricas dos círculos' do
      get "/frames/#{frame.id}", as: :json
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['center_x'].to_f).to eq(50.0)
      expect(body['center_y'].to_f).to eq(50.0)
      expect(body['metrics']['highest'].to_f).to eq(80.0)
      expect(body['metrics']['lowest'].to_f).to eq(20.0)
      expect(body['metrics']['leftmost'].to_f).to eq(40.0)
      expect(body['metrics']['rightmost'].to_f).to eq(90.0)
    end
  end

  describe 'DELETE /frames/:id' do
    let!(:frame_without_circles) { Frame.create!(center_x: 200, center_y: 200, width: 50, height: 50) }
    let!(:frame_with_circle) do
      frame = Frame.create!(center_x: 300, center_y: 300, width: 60, height: 60)
      frame.circles.create!(center_x: 310, center_y: 310, diameter: 10)
      frame
    end

    it 'removes a frame with no circles and returns 204' do
      delete "/frames/#{frame_without_circles.id}", as: :json
      expect(response).to have_http_status(:no_content)
      expect(Frame.find_by(id: frame_without_circles.id)).to be_nil
    end

    it 'does not remove a frame with circles and returns 422' do
      delete "/frames/#{frame_with_circle.id}", as: :json
      expect(response).to have_http_status(:unprocessable_content)
      expect(Frame.find_by(id: frame_with_circle.id)).not_to be_nil
      expect(JSON.parse(response.body)['errors']).to include('Quadro possui círculos associados')
    end

    it 'returns 404 if frame does not exist' do
      delete "/frames/999999", as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /frames/:id' do
    let!(:frame_without_circles) { Frame.create!(center_x: 200, center_y: 200, width: 50, height: 50) }
    let!(:frame_with_circle) do
      frame = Frame.create!(center_x: 300, center_y: 300, width: 60, height: 60)
      frame.circles.create!(center_x: 310, center_y: 310, diameter: 10)
      frame
    end

    it 'removes a frame with no circles and returns 204' do
      delete "/frames/#{frame_without_circles.id}", as: :json
      expect(response).to have_http_status(:no_content)
      expect(Frame.find_by(id: frame_without_circles.id)).to be_nil
    end

    it 'does not remove a frame with circles and returns 422' do
      delete "/frames/#{frame_with_circle.id}", as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Frame.find_by(id: frame_with_circle.id)).not_to be_nil
      expect(JSON.parse(response.body)['errors']).to include('Quadro possui círculos associados')
    end

    it 'returns 404 if frame does not exist' do
      delete "/frames/999999", as: :json
      expect(response).to have_http_status(:not_found)
    end
  end
end
