require 'rails_helper'

RSpec.describe "Circles", type: :request do
  describe 'POST /frames/:frame_id/circles' do
    let!(:frame) { Frame.create!(center_x: 50, center_y: 50, width: 100, height: 100) }

    it 'adiciona um círculo válido ao quadro' do
      params = {
        circle: {
          center_x: 60,
          center_y: 60,
          diameter: 20
        }
      }
      post "/frames/#{frame.id}/circles", params: params, as: :json
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['center_x'].to_f).to eq(60.0)
    end

    it 'retorna erro se o círculo sobrepõe outro' do
      frame.circles.create!(center_x: 60, center_y: 60, diameter: 30)
      params = {
        circle: {
          center_x: 70,
          center_y: 60,
          diameter: 30
        }
      }
      post "/frames/#{frame.id}/circles", params: params, as: :json
      expect(response).to have_http_status(:unprocessable_content)
      expect(JSON.parse(response.body)['errors']).to be_present
    end

    describe 'PUT /circles/:id' do
      let!(:circle) { frame.circles.create!(center_x: 60, center_y: 60, diameter: 20) }

      it 'atualiza a posição de um círculo existente' do
        params = {
          circle: {
            center_x: 70,
            center_y: 70
          }
        }
        put "/circles/#{circle.id}", params: params, as: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['center_x'].to_f).to eq(70.0)
      end

      it 'retorna erro se a atualização causa sobreposição' do
        frame.circles.create!(center_x: 30, center_y: 30, diameter: 30) # posição válida
        params = {
          circle: {
            center_x: 30,
            center_y: 30
          }
        }
        put "/circles/#{circle.id}", params: params, as: :json
        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end

  describe 'GET /circles' do
    let!(:frame) { Frame.create!(center_x: 50, center_y: 50, width: 100, height: 100) }
    let!(:circle1) { frame.circles.create!(center_x: 60, center_y: 60, diameter: 10) }
    let!(:circle2) { frame.circles.create!(center_x: 80, center_y: 80, diameter: 10) }
    let!(:circle3) { frame.circles.create!(center_x: 90, center_y: 90, diameter: 10) }

    it 'lista círculos dentro do raio especificado' do
      get '/circles', params: { center_x: 60, center_y: 60, radius: 25 }
      expect(response).to have_http_status(:ok)
      ids = JSON.parse(response.body).map { |c| c['id'] }
      expect(ids).to include(circle1.id)
      expect(ids).not_to include(circle2.id)
      expect(ids).not_to include(circle3.id)
    end

    it 'filtra círculos por quadro' do
      get '/circles', params: { center_x: 60, center_y: 60, radius: 25, frame_id: frame.id }
      expect(response).to have_http_status(:ok)
      ids = JSON.parse(response.body).map { |c| c['id'] }
      expect(ids).to include(circle1.id)
    end
  end

  describe 'DELETE /circles/:id' do
    let!(:frame) { Frame.create!(center_x: 50, center_y: 50, width: 100, height: 100) }
    let(:circle) { frame.circles.create!(center_x: 61, center_y: 61, diameter: 10) }
    let(:valid_attributes) { { center_x: 80, center_y: 80 } }

    it 'updates the circle' do
      put "/circles/#{circle.id}", params: { circle: valid_attributes }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['center_x'].to_f).to eq(80.0)
      expect(body['center_y'].to_f).to eq(80.0)
    end

    it 'returns errors for invalid update' do
      put "/circles/#{circle.id}", params: { circle: { diameter: -1 } }
      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body['errors']).to include('Diameter must be greater than 0')
    end

    it 'returns 404 if circle does not exist' do
      put "/circles/999999", params: { circle: valid_attributes }
      expect(response).to have_http_status(:not_found)
      body = JSON.parse(response.body)
      expect(body['error']).to eq('Circle not found')
    end
    it 'remove um círculo existente e retorna 204' do
      delete "/circles/#{circle.id}", as: :json
      expect(response).to have_http_status(:no_content)
      expect(Circle.find_by(id: circle.id)).to be_nil
    end

    it 'retorna 404 se o círculo não existir' do
      delete "/circles/999999", as: :json
      expect(response).to have_http_status(:not_found)
      body = JSON.parse(response.body)
      expect(body['error']).to eq('Circle not found')
    end
  end
end
