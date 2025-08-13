class FramesController < ApplicationController
  def create
    frame = Frame.new(frame_params)
    if frame.save
      render json: frame.as_json(include: :circles), status: :created
    else
      render json: { errors: frame.errors.full_messages }, status: :unprocessable_content
    end
  end

  def show
    frame = Frame.find(params[:id])
    circles = frame.circles
    metrics = {
      total_circles: circles.size,
      highest: circles.max_by(&:center_y)&.center_y,
      lowest: circles.min_by(&:center_y)&.center_y,
      leftmost: circles.min_by(&:center_x)&.center_x,
      rightmost: circles.max_by(&:center_x)&.center_x
    }
    render json: {
      id: frame.id,
      center_x: frame.center_x,
      center_y: frame.center_y,
      width: frame.width,
      height: frame.height,
      circles: circles,
      metrics: metrics
    }, status: :ok
  end

  def destroy
    frame = Frame.find_by(id: params[:id])
    if frame.nil?
      head :not_found
    elsif frame.circles.any?
  render json: { errors: ['Quadro possui círculos associados'] }, status: :unprocessable_content
    else
      frame.destroy
      head :no_content
    end
  end

  private

  def frame_params
    params.require(:frame).permit(:center_x, :center_y, :width, :height, circles_attributes: [:center_x, :center_y, :diameter])
  end
end
