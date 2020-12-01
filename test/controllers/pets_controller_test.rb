require "test_helper"

describe PetsController do
  PET_FIELDS = ["id", "name", "age", "owner", "species"].sort

  describe "index" do
    it "must get index" do
      get pets_path

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :ok
    end

  it "will return all the proper fields for a list of pets" do
    # Act
    get pets_path
    # Takes the body of the server's response
    # as an array or hash
    body = JSON.parse(response.body)

    # Assert
    # Ensures that the response is an array
    expect(body).must_be_instance_of Array

    body.each do |pet|
      expect(pet).must_be_instance_of Hash
      # Ensures that each response has only the id, name, species, age, and owner fields
      expect(pet.keys.sort).must_equal PET_FIELDS.sort
    end
  end

  it "will respond with an empty array if there are no pets" do
    # Arrange
    Pet.destroy_all

    # Act
    get pets_path
    body = JSON.parse(response.body)

    # Assert
    expect(body).must_be_instance_of Array
    expect(body).must_equal []
    # expect(body.length).must_equal 0
  end

  describe "show" do
    #Nominal test case
    it "will return a hash with the proper fields for an existing pet" do
      pet = pets(:churro)

      #Act
      get pet_path(pet.id)

      body = JSON.parse(response.body)

      must_respond_with :ok
      expect(response.header['Content-Type']).must_include 'json'

      expect(body).must_be_instance_of Hash
      expect(body.keys.sort).must_equal PET_FIELDS.sort
    end


  # Edge case
    it "will return 404 with JSON for a non-existent pet" do
      get pet_path(-1)

      # must_respond_with :not_found
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body["ok"]).must_equal false
      expect(body["message"]).must_equal "Not Found"
    end
  end
  end

  describe "create" do

    let(:pet_data) {
        {   #everything needs to be in a single hash
            pet: {
            name: "Churro",
            owner: "Sandy",
            species: "Cat",
            age: 3
            }
        }
    }
    # Nominal case
    it "can create a new pet" do
      # create action should be nested hashes

      expect{post pets_path, params: pet_data}.must_differ "Pet.count", 1
      must_respond_with :created
    end

    it "gives bad_request when user gives bad data" do
      # this is testing the validation on the presence of name for the Pet Model
      pet_data[:pet][:name] = nil  #let runs a new instance for every test


      expect{
        # Act
        post pets_path, params: pet_data
        # Assert
      }.wont_change "Pet.count"

      must_respond_with :bad_request  #tests breaks with this for some reason

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"].keys).must_include "name"

    end
  end
end
