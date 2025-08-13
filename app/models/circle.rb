class Circle < ApplicationRecord
  belongs_to :frame

  validates :center_x, :center_y, :diameter, presence: true
  validates :diameter, numericality: { greater_than: 0 }

  validate :fits_within_frame
  validate :no_circle_overlap

  private

  def fits_within_frame
    return unless frame
    r = diameter / 2.0
    left   = center_x - r
    right  = center_x + r
    top    = center_y - r
    bottom = center_y + r
    frame_left   = frame.center_x - frame.width / 2.0
    frame_right  = frame.center_x + frame.width / 2.0
    frame_top    = frame.center_y - frame.height / 2.0
    frame_bottom = frame.center_y + frame.height / 2.0
    unless left >= frame_left && right <= frame_right && top >= frame_top && bottom <= frame_bottom
      errors.add(:base, 'Círculo deve caber completamente dentro do quadro')
    end
  end

  def no_circle_overlap
    return unless frame
    frame.circles.where.not(id: id).find_each do |other|
      dist = Math.sqrt((center_x - other.center_x)**2 + (center_y - other.center_y)**2)
      if dist < (diameter + other.diameter) / 2.0
        errors.add(:base, 'Círculos não podem se tocar ou sobrepor')
      end
    end
  end
end
