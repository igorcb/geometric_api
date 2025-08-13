require 'rails_helper'

describe Frame, type: :model do
  it 'tem muitos círculos' do
    assoc = described_class.reflect_on_association(:circles)
    expect(assoc.macro).to eq(:has_many)
  end
  it 'não permite círculos sobrepostos' do
    frame = Frame.new(center_x: 50, center_y: 50, width: 100, height: 100)
    frame.circles.build(center_x: 60, center_y: 60, diameter: 30)
    frame.circles.build(center_x: 70, center_y: 60, diameter: 30)
    expect(frame).not_to be_valid
    expect(frame.errors[:circles]).to include('Círculos não podem se tocar ou sobrepor')
  end

  it 'permite círculos não sobrepostos' do
    frame = Frame.new(center_x: 50, center_y: 50, width: 100, height: 100)
    frame.circles.build(center_x: 60, center_y: 60, diameter: 20)
    frame.circles.build(center_x: 80, center_y: 80, diameter: 10)
    expect(frame).to be_valid
  end
end
