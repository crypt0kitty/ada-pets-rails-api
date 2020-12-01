class PetsController < ApplicationController
  def index
    pets = Pet.all.order(:name)
    # Our test wants a list of pets. Rails knows how to convert a model collection into JSON.
    # Sweet! We can do so by passing the list of pets into the render method.
    render json: pets.as_json(only: [:id, :name, :age, :owner, :species]),
           status: :ok
  end

  def show
    pet = Pet.find_by(id: params[:id])

    if pet.nil?
      render json: {
          ok: false,
          message: "Not Found",
          status: :not_found
      }
      return
    end

    # if pet found
    render json: pet.as_json(only: [:id, :name, :age, :owner, :species]),
           status: :ok

  end

  def create
    pet = Pet.new(pet_params)

    if pet.save
      render json: pet.as_json(only:[:id]), status: :created
    else
      #TO DO
      render json:{errors: pet.errors.messages}, status: :bad_request
    end
  end



  private

  def pet_params
    return params.require(:pet).permit(:name, :age, :owner, :species)
  end
end
