class CirclesController < ApplicationController
  def create
    frame = Frame.find(params[:frame_id])
    circle = frame.circles.build(circle_params)
    if circle.save
      render json: circle, status: :created
    else
      render json: { errors: circle.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    circle = Circle.find_by(id: params[:id])
    unless circle
      render json: { error: 'Circle not found' }, status: :not_found
      return
    end
    if circle.update(circle_params)
      render json: circle, status: :ok
    else
      render json: { errors: circle.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    center_x = params[:center_x].to_f
    center_y = params[:center_y].to_f
    radius = params[:radius].to_f
    circles = Circle.all
    circles = circles.where(frame_id: params[:frame_id]) if params[:frame_id].present?
    result = circles.select do |circle|
      dist = Math.sqrt((circle.center_x - center_x)**2 + (circle.center_y - center_y)**2)
      dist + circle.diameter / 2.0 <= radius
    end
    render json: result, status: :ok
  end

  def destroy
    circle = Circle.find_by(id: params[:id])
    if circle
      circle.destroy
      head :no_content
    else
      render json: { error: 'Circle not found' }, status: :not_found
    end
  end

  private

  def circle_params
    params.require(:circle).permit(:center_x, :center_y, :diameter)
  end
end
