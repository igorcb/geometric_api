class Frame < ApplicationRecord
  has_many :circles, dependent: :destroy
  accepts_nested_attributes_for :circles

  validates :center_x, :center_y, :width, :height, presence: true
  validates :width, :height, numericality: { greater_than: 0 }

  validate :no_frame_overlap
  validate :no_circles_overlap

  private

  def no_frame_overlap
    Frame.where.not(id: id).find_each do |other|
      if overlap_with?(other)
        errors.add(:base, 'Quadro não pode tocar ou sobrepor outro quadro')
      end
    end
  end

  def overlap_with?(other)
    left   = center_x - width / 2.0
    right  = center_x + width / 2.0
    top    = center_y - height / 2.0
    bottom = center_y + height / 2.0

    o_left   = other.center_x - other.width / 2.0
    o_right  = other.center_x + other.width / 2.0
    o_top    = other.center_y - other.height / 2.0
    o_bottom = other.center_y + other.height / 2.0

    !(right < o_left || left > o_right || bottom < o_top || top > o_bottom)
  end

  def no_circles_overlap
    all_circles = circles.to_a
    all_circles.combination(2).each do |a, b|
      dist = Math.sqrt((a.center_x - b.center_x)**2 + (a.center_y - b.center_y)**2)
      if dist < (a.diameter / 2.0 + b.diameter / 2.0)
        errors.add(:circles, 'Círculos não podem se tocar ou sobrepor')
        break
      end
    end
  end
end
