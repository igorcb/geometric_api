require 'rails_helper'


describe Circle, type: :model do
  let(:frame) { Frame.create!(center_x: 50, center_y: 50, width: 100, height: 100) }
  it 'pertence a um frame' do
    assoc = described_class.reflect_on_association(:frame)
    expect(assoc.macro).to eq(:belongs_to)
  end

  it 'é inválido sem frame' do
    circle = Circle.new(center_x: 60, center_y: 60, diameter: 20)
    expect(circle).not_to be_valid
    expect(circle.errors[:frame]).to be_present
  end

  it 'é inválido com diâmetro zero ou negativo' do
    circle = frame.circles.build(center_x: 60, center_y: 60, diameter: 0)
    expect(circle).not_to be_valid
    expect(circle.errors[:diameter]).to be_present

    circle = frame.circles.build(center_x: 60, center_y: 60, diameter: -5)
    expect(circle).not_to be_valid
    expect(circle.errors[:diameter]).to be_present
  end

  it 'é inválido se não couber completamente dentro do quadro' do
    circle = frame.circles.build(center_x: 10, center_y: 10, diameter: 100)
    expect(circle).not_to be_valid
    expect(circle.errors[:base]).to include('Círculo deve caber completamente dentro do quadro')
  end

  it 'é inválido se sobrepor outro círculo no mesmo quadro' do
    frame.circles.create!(center_x: 60, center_y: 60, diameter: 20)
    circle = frame.circles.build(center_x: 65, center_y: 60, diameter: 20)
    expect(circle).not_to be_valid
    expect(circle.errors[:base]).to include('Círculos não podem se tocar ou sobrepor')
  end

  it 'é válido com dados corretos e sem sobreposição' do
    circle = frame.circles.build(center_x: 80, center_y: 80, diameter: 10)
    expect(circle).to be_valid
  end

  let(:frame) { Frame.create!(center_x: 50, center_y: 50, width: 100, height: 100) }

  it 'é inválido sem frame' do
    circle = Circle.new(center_x: 60, center_y: 60, diameter: 20)
    expect(circle).not_to be_valid
    expect(circle.errors[:frame]).to be_present
  end

  it 'é inválido com diâmetro zero ou negativo' do
    circle = frame.circles.build(center_x: 60, center_y: 60, diameter: 0)
    expect(circle).not_to be_valid
    expect(circle.errors[:diameter]).to be_present

    circle = frame.circles.build(center_x: 60, center_y: 60, diameter: -5)
    expect(circle).not_to be_valid
    expect(circle.errors[:diameter]).to be_present
  end

  it 'é válido com dados corretos' do
    circle = frame.circles.build(center_x: 60, center_y: 60, diameter: 20)
    expect(circle).to be_valid
  end
end
